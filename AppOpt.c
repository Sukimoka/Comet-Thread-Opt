#define _GNU_SOURCE
#include <ctype.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <fnmatch.h>
#include <getopt.h>
#include <sched.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#define BASE_CPUSET        "/dev/cpuset/AppOpt"
#define MAX_PKG_LEN        128
#define MAX_THREAD_LEN     32

typedef struct {
    char pkg[MAX_PKG_LEN];
    char thread[MAX_THREAD_LEN];
    char cpuset_dir[256];
    cpu_set_t cpus;
} AffinityRule;

typedef struct {
    pid_t tid;
    char name[MAX_THREAD_LEN];
    char cpuset_dir[256];
    cpu_set_t cpus;
} ThreadInfo;

typedef struct {
    pid_t pid;
    char pkg[MAX_PKG_LEN];
    char base_cpuset[128];
    cpu_set_t base_cpus;
    ThreadInfo* threads;
    size_t num_threads;
    AffinityRule** thread_rules;
    size_t num_thread_rules;
} ProcessInfo;

typedef struct {
    cpu_set_t present_cpus;
    char present_str[128];
    char mems_str[32];
    bool cpuset_enabled;
    int base_cpuset_fd;
} CpuTopology;

typedef struct {
    AffinityRule* rules;
    size_t num_rules;
    time_t mtime;
    CpuTopology topo;
    char** pkgs;
    size_t num_pkgs;
    char config_file[4096];
} AppConfig;

typedef struct {
    ProcessInfo* procs;
    size_t num_procs;
    int last_proc_count;
} ProcCache;

static char* strtrim(char* s) {
    char* end;
    while (isspace(*s)) s++;
    if (*s == 0) return s;
    end = s + strlen(s) - 1;
    while (end > s && isspace(*end)) end--;
    *(end + 1) = 0;
    return s;
}

static bool read_file(int dir_fd, const char* filename, char* buf, size_t buf_size) {
    int fd = openat(dir_fd, filename, O_RDONLY | O_CLOEXEC);
    if (fd == -1) return false;
    ssize_t total = 0;
    while (total < (ssize_t)(buf_size - 1)) {
        ssize_t n = read(fd, buf + total, buf_size - 1 - total);
        if (n == -1) {
            if (errno == EINTR) continue;
            break;
        }
        if (n == 0) break;
        total += n;
    }
    close(fd);
    if (total <= 0) return false;
    buf[total] = '\0';
    return true;
}

static bool write_file(int dir_fd, const char* filename, const char* content, int flags) {
    int fd = openat(dir_fd, filename, flags | O_CLOEXEC, 0644);
    if (fd == -1) return false;
    const char* ptr = content;
    size_t remaining = strlen(content);
    while (remaining > 0) {
        ssize_t n = write(fd, ptr, remaining);
        if (n == -1) {
            if (errno == EINTR) continue;
            close(fd);
            return false;
        }
        ptr += n;
        remaining -= n;
    }
    close(fd);
    return true;
}

static void parse_cpu_ranges(const char* spec, cpu_set_t* set, const cpu_set_t* present) {
    if (!spec) return;
    char* copy = strdup(spec);
    if (!copy) return;
    char* s = copy;

    while (*s) {
        char* end;
        unsigned long a = strtoul(s, &end, 10);
        if (end == s) {
            s++;
            continue;
        }

        unsigned long b = a;
        if (*end == '-') {
            s = end + 1;
            b = strtoul(s, &end, 10);
            if (end == s) b = a;
        }

        if (a > b) { unsigned long t = a; a = b; b = t; }
        for (unsigned long i = a; i <= b && i < CPU_SETSIZE; i++) {
            if (present && !CPU_ISSET(i, present)) continue;
            CPU_SET(i, set);
        }

        s = (*end == ',') ? end + 1 : end;
    }
    free(copy);
}

static char* cpu_set_to_str(const cpu_set_t *set) {
    size_t buf_size = 8 * CPU_SETSIZE;
    char *buf = malloc(buf_size);
    if (!buf) return NULL;
    int start = -1, end = -1;
    char *p = buf;
    size_t remain = buf_size - 1;
    bool first = true;

    for (int i = 0; i < CPU_SETSIZE; i++) {
        if (CPU_ISSET(i, set)) {
            if (start == -1) {
                start = end = i;
            } else if (i == end + 1) {
                end = i;
            } else {
                int needed;
                if (start == end) {
                    needed = snprintf(p, remain + 1, "%s%d", first ? "" : ",", start);
                } else {
                    needed = snprintf(p, remain + 1, "%s%d-%d", first ? "" : ",", start, end);
                }
                if (needed < 0 || (size_t)needed > remain) {
                    free(buf);
                    return NULL;
                }
                p += needed;
                remain -= needed;
                start = end = i;
                first = false;
            }
        }
    }
    if (start != -1) {
        int needed;
        if (start == end) {
            needed = snprintf(p, remain + 1, "%s%d", first ? "" : ",", start);
        } else {
            needed = snprintf(p, remain + 1, "%s%d-%d", first ? "" : ",", start, end);
        }
        if (needed < 0 || (size_t)needed > remain) {
            free(buf);
            return NULL;
        }
        p += needed;
    }
    *p = '\0';
    return buf;
}

static bool create_cpuset_dir(const char *path, const char *cpus, const char *mems) {
    if (mkdir(path, 0755) != 0 && errno != EEXIST) return false;
    if (chmod(path, 0755) != 0) return false;
    if (chown(path, 0, 0) != 0) return false;

    char cpus_path[256];
    snprintf(cpus_path, sizeof(cpus_path), "%s/cpus", path);
    if (!write_file(AT_FDCWD, cpus_path, cpus, O_WRONLY | O_CREAT | O_TRUNC)) return false;

    char mems_path[256];
    snprintf(mems_path, sizeof(mems_path), "%s/mems", path);
    return write_file(AT_FDCWD, mems_path, mems, O_WRONLY | O_CREAT | O_TRUNC);
}

static CpuTopology init_cpu_topo(void) {
    CpuTopology topo = { .cpuset_enabled = false, .base_cpuset_fd = -1 };
    CPU_ZERO(&topo.present_cpus);

    if (read_file(AT_FDCWD, "/sys/devices/system/cpu/present", topo.present_str, sizeof(topo.present_str))) {
        strtrim(topo.present_str);
    }
    parse_cpu_ranges(topo.present_str, &topo.present_cpus, NULL);

    if (access("/dev/cpuset", F_OK) != 0) return topo;

    if (create_cpuset_dir(BASE_CPUSET, topo.present_str, "0")) {
        topo.base_cpuset_fd = open(BASE_CPUSET, O_RDONLY | O_DIRECTORY);
        if (topo.base_cpuset_fd != -1) topo.cpuset_enabled = true;
    }

    char mems_path[256];
    snprintf(mems_path, sizeof(mems_path), "%s/mems", BASE_CPUSET);
    if (!read_file(AT_FDCWD, mems_path, topo.mems_str, sizeof(topo.mems_str))) {
        strcpy(topo.mems_str, "0");
    } else {
        strtrim(topo.mems_str);
    }

    return topo;
}

static bool load_config(AppConfig* cfg) {
    struct stat st;
    if (stat(cfg->config_file, &st) != 0) {
        const char* initial_content = "# 规则编写与使用说明请参考 http://AppOpt.suto.top\n\n";
        if (write_file(AT_FDCWD, cfg->config_file, initial_content, O_WRONLY | O_CREAT | O_TRUNC)) {
            cfg->mtime = 0;
        }
        return false;
    }

    if (st.st_mtime <= cfg->mtime) return false;
    FILE* fp = fopen(cfg->config_file, "r");
    if (!fp) return false;

    AffinityRule* new_rules = NULL;
    char** new_pkgs = NULL;
    size_t rules_cnt = 0, pkgs_cnt = 0;
    char line[256];

    while (fgets(line, sizeof(line), fp)) {
        char* p = strtrim(line);
        if (*p == '#' || !*p) continue;

        char* eq = strchr(p, '=');
        if (!eq) continue;
        *eq++ = 0;

        char* br = strchr(p, '{');
        char* thread = "";
        if (br) {
            *br++ = 0;
            char* eb = strchr(br, '}');
            if (!eb) continue;
            *eb = 0;
            thread = strtrim(br);
        }

        char* pkg = strtrim(p);
        char* cpus = strtrim(eq);
        if (strlen(pkg) >= MAX_PKG_LEN || strlen(thread) >= MAX_THREAD_LEN) continue;

        cpu_set_t set;
        CPU_ZERO(&set);
        parse_cpu_ranges(cpus, &set, &cfg->topo.present_cpus);
        if (CPU_COUNT(&set) == 0) continue;

        char* dir_name = cpu_set_to_str(&set);
        if (!dir_name) continue;

        char path[256];
        snprintf(path, sizeof(path), "%s/%s", BASE_CPUSET, dir_name);
        if (!create_cpuset_dir(path, dir_name, cfg->topo.mems_str)) {
            free(dir_name);
            continue;
        }

        AffinityRule rule = {0};
        strncpy(rule.pkg, pkg, MAX_PKG_LEN - 1);
        rule.pkg[MAX_PKG_LEN - 1] = '\0';
        strncpy(rule.thread, thread, MAX_THREAD_LEN - 1);
        rule.thread[MAX_THREAD_LEN - 1] = '\0';
        strncpy(rule.cpuset_dir, dir_name, sizeof(rule.cpuset_dir) - 1);
        rule.cpuset_dir[sizeof(rule.cpuset_dir) - 1] = '\0';
        rule.cpus = set;
        free(dir_name);

        AffinityRule* tmp_rules = realloc(new_rules, (rules_cnt + 1) * sizeof(AffinityRule));
        if (!tmp_rules) goto error;
        new_rules = tmp_rules;
        memcpy(&new_rules[rules_cnt], &rule, sizeof(AffinityRule));
        rules_cnt++;

        bool exists = false;
        if (new_pkgs != NULL) {
            for (size_t i = 0; i < pkgs_cnt; i++) {
                if (strcmp(new_pkgs[i], pkg) == 0) {
                    exists = true;
                    break;
                }
            }
        }
        if (!exists) {
            char** tmp_pkgs = realloc(new_pkgs, (pkgs_cnt + 1) * sizeof(char*));
            if (!tmp_pkgs) goto error;
            new_pkgs = tmp_pkgs;
            new_pkgs[pkgs_cnt] = strdup(pkg);
            if (!new_pkgs[pkgs_cnt]) goto error;
            pkgs_cnt++;
        }
    }

    free(cfg->rules);
    if (cfg->pkgs != NULL) {
        for (size_t i = 0; i < cfg->num_pkgs; i++) free(cfg->pkgs[i]);
        free(cfg->pkgs);
    }

    cfg->rules = new_rules;
    cfg->num_rules = rules_cnt;
    cfg->pkgs = new_pkgs;
    cfg->num_pkgs = pkgs_cnt;
    cfg->mtime = st.st_mtime;

    fclose(fp);
    printf("Config file loaded, Total of %zu rules.\n", rules_cnt);
    return true;

error:
    free(new_rules);
    if (new_pkgs != NULL) {
        for (size_t i = 0; i < pkgs_cnt; i++) free(new_pkgs[i]);
        free(new_pkgs);
    }
    fclose(fp);
    return false;
}

static ProcessInfo* proc_collect(const AppConfig* cfg, size_t* count) {
    DIR* proc_dir = opendir("/proc");
    if (!proc_dir) return NULL;
    int proc_fd = dirfd(proc_dir);
    size_t proc_cap = 2048;
    ProcessInfo* new_procs = malloc(proc_cap * sizeof(ProcessInfo));
    if (!new_procs) {
        closedir(proc_dir);
        return NULL;
    }
    *count = 0;
    struct dirent* ent;

    while ((ent = readdir(proc_dir))) {
        if (ent->d_type != DT_DIR || !isdigit(ent->d_name[0])) continue;

        char* endptr;
        unsigned long pid_ul = strtoul(ent->d_name, &endptr, 10);
        if (*endptr != '\0') continue;
        pid_t pid = (pid_t)pid_ul;

        int pid_fd = openat(proc_fd, ent->d_name, O_RDONLY | O_DIRECTORY);
        if (pid_fd == -1) continue;

        char cmd[MAX_PKG_LEN] = {0};
        if (!read_file(pid_fd, "cmdline", cmd, sizeof(cmd))) {
            close(pid_fd);
            continue;
        }

        char* name = strrchr(cmd, '/');
        name = name ? name + 1 : cmd;

        bool found = false;
        for (size_t j = 0; j < cfg->num_pkgs; j++) {
            if (strcmp(name, cfg->pkgs[j]) == 0) {
                found = true;
                break;
            }
        }
        if (!found) {
            close(pid_fd);
            continue;
        }

        ProcessInfo proc = {0};
        proc.pid = pid;
        strncpy(proc.pkg, name, MAX_PKG_LEN - 1);
        proc.pkg[MAX_PKG_LEN - 1] = '\0';
        CPU_ZERO(&proc.base_cpus);
        proc.base_cpuset[0] = '\0';

        size_t thrules_cap = 4;
        proc.thread_rules = malloc(thrules_cap * sizeof(AffinityRule*));
        if (!proc.thread_rules) {
            close(pid_fd);
            continue;
        }
        proc.num_thread_rules = 0;

        for (size_t i = 0; i < cfg->num_rules; i++) {
            const AffinityRule* rule = &cfg->rules[i];
            if (strcmp(rule->pkg, proc.pkg) != 0) continue;

            if (rule->thread[0]) {
                if (proc.num_thread_rules >= thrules_cap) {
                    thrules_cap *= 2;
                    AffinityRule** tmp = realloc(proc.thread_rules, thrules_cap * sizeof(AffinityRule*));
                    if (!tmp) break;
                    proc.thread_rules = tmp;
                }
                proc.thread_rules[proc.num_thread_rules++] = (AffinityRule*)rule;
            } else {
                CPU_OR(&proc.base_cpus, &proc.base_cpus, &rule->cpus);
                strncpy(proc.base_cpuset, rule->cpuset_dir, sizeof(proc.base_cpuset) - 1);
                proc.base_cpuset[sizeof(proc.base_cpuset) - 1] = '\0';
            }
        }

        if (CPU_COUNT(&proc.base_cpus) == 0 && proc.num_thread_rules == 0) {
            close(pid_fd);
            free(proc.thread_rules);
            continue;
        }

        int task_fd = openat(pid_fd, "task", O_RDONLY | O_DIRECTORY);
        close(pid_fd);
        if (task_fd == -1) {
            free(proc.thread_rules);
            continue;
        }

        DIR* task_dir = fdopendir(task_fd);
        if (!task_dir) {
            close(task_fd);
            free(proc.thread_rules);
            continue;
        }

        size_t thread_cap = 128;
        ThreadInfo* threads = malloc(thread_cap * sizeof(ThreadInfo));
        if (!threads) {
            closedir(task_dir);
            free(proc.thread_rules);
            continue;
        }
        size_t tcount = 0;
        struct dirent* tent;

        while ((tent = readdir(task_dir))) {
            if (tent->d_type != DT_DIR || !isdigit(tent->d_name[0])) continue;

            char* endptr2;
            unsigned long tid_ul = strtoul(tent->d_name, &endptr2, 10);
            if (*endptr2 != '\0') continue;
            pid_t tid = (pid_t)tid_ul;

            char tname[MAX_THREAD_LEN] = {0};

            int tid_fd = openat(task_fd, tent->d_name, O_RDONLY | O_DIRECTORY);
            if (tid_fd == -1) continue;

            if (!read_file(tid_fd, "comm", tname, sizeof(tname))) {
                close(tid_fd);
                continue;
            }
            close(tid_fd);

            strtrim(tname);
            ThreadInfo ti = { .tid = tid };
            strncpy(ti.name, tname, MAX_THREAD_LEN - 1);
            ti.name[MAX_THREAD_LEN - 1] = '\0';
            ti.cpus = proc.base_cpus;
            strncpy(ti.cpuset_dir, proc.base_cpuset, sizeof(ti.cpuset_dir) - 1);
            ti.cpuset_dir[sizeof(ti.cpuset_dir) - 1] = '\0';

            for (size_t i = 0; i < proc.num_thread_rules; i++) {
                const AffinityRule* rule = proc.thread_rules[i];
                if (fnmatch(rule->thread, ti.name, FNM_NOESCAPE) == 0) {
                    CPU_OR(&ti.cpus, &ti.cpus, &rule->cpus);
                    strncpy(ti.cpuset_dir, rule->cpuset_dir, sizeof(ti.cpuset_dir) - 1);
                    ti.cpuset_dir[sizeof(ti.cpuset_dir) - 1] = '\0';
                }
            }

            if (tcount >= thread_cap) {
                thread_cap *= 2;
                ThreadInfo* tmp = realloc(threads, thread_cap * sizeof(ThreadInfo));
                if (!tmp) continue;
                threads = tmp;
            }
            threads[tcount++] = ti;
        }

        proc.threads = threads;
        proc.num_threads = tcount;

        if (*count >= proc_cap) {
            proc_cap *= 2;
            ProcessInfo* tmp = realloc(new_procs, proc_cap * sizeof(ProcessInfo));
            if (!tmp) {
                free(threads);
                free(proc.thread_rules);
                closedir(task_dir);
                continue;
            }
            new_procs = tmp;
        }
        new_procs[(*count)++] = proc;
        closedir(task_dir);
    }
    closedir(proc_dir);
    return new_procs;
}

static int get_proc_count(void) {
    char buf[64];
    if (!read_file(AT_FDCWD, "/proc/loadavg", buf, sizeof(buf))) return -1;
    char *pos = buf, *slash;
    for (int i = 0; i < 3; i++) {
        pos = strchr(pos, ' ');
        if (!pos) return -1;
        pos++;
    }
    slash = strchr(pos, '/');
    if (!slash || slash == pos) return -1;

    char *endptr;
    (void)strtoul(pos, &endptr, 10);
    if (endptr != slash) return -1;
    unsigned long total = strtoul(slash + 1, &endptr, 10);
    if (*endptr != ' ' && *endptr != '\0') return -1;

    return (int)total;
}

static void update_cache(ProcCache* cache, const AppConfig* cfg, int* affinity_counter) {
    int current_proc_count = get_proc_count();
    if (current_proc_count == -1) return;
    if (current_proc_count > cache->last_proc_count + 5) {
        size_t count;
        ProcessInfo* new_procs = proc_collect(cfg, &count);
        if (!new_procs) return;

        if (cache->procs) {
            for (size_t i = 0; i < cache->num_procs; i++) {
                free(cache->procs[i].threads);
                free(cache->procs[i].thread_rules);
            }
            free(cache->procs);
        }
        cache->procs = new_procs;
        cache->num_procs = count;
        *affinity_counter = 9;
    }
    cache->last_proc_count = current_proc_count;
}

static void apply_affinity(ProcCache* cache, const CpuTopology* topo) {
    for (size_t i = 0; i < cache->num_procs; i++) {
        const ProcessInfo* proc = &cache->procs[i];
        for (size_t j = 0; j < proc->num_threads; j++) {
            const ThreadInfo* ti = &proc->threads[j];
            if (topo->cpuset_enabled && topo->base_cpuset_fd != -1) {
                char tid_str[32];
                snprintf(tid_str, sizeof(tid_str), "%d\n", ti->tid);
                if (CPU_COUNT(&ti->cpus) == 0) {
                    write_file(topo->base_cpuset_fd, "tasks", tid_str, O_WRONLY | O_APPEND);
                } else {
                    if (ti->cpuset_dir[0]) {
                        int fd = openat(topo->base_cpuset_fd, ti->cpuset_dir, O_RDONLY | O_DIRECTORY);
                        if (fd != -1) {
                            write_file(fd, "tasks", tid_str, O_WRONLY | O_APPEND);
                            close(fd);
                        }
                    }
                }
            }
            if (CPU_COUNT(&ti->cpus) == 0) continue;
            if (sched_setaffinity(ti->tid, sizeof(ti->cpus), &ti->cpus) == -1 && errno == ESRCH) {
                cache->last_proc_count = 0;
            }
        }
    }
}

static struct option long_options[] = {
    {"config", required_argument, NULL, 'c'},
    {"sleep",  required_argument, NULL, 's'},
    {"help",   no_argument,       NULL, 'h'},
    {0, 0, 0, 0}
};

static void print_help(const char* prog_name) {
    printf("Usage: %s [OPTIONS]\n", prog_name);
    printf("Options:\n");
    printf("  -c, --config <file> Specify configuration file (default: ./applist.conf)\n");
    printf("  -s, --sleep <sec>   Set sleep interval in seconds (must be >=1, default: 3)\n");
    printf("  -h, --help          Display this help message\n");
    printf("\nExample:\n");
    printf("  %s -c /data/applist.conf -s 3\n", prog_name);
}

int main(int argc, char **argv) {
    AppConfig config = { .topo = init_cpu_topo() };
    strncpy(config.config_file, "./applist.conf", sizeof(config.config_file) -1);
    config.config_file[sizeof(config.config_file)-1] = '\0';
    int sleep_interval = 3;

    int opt;
    int option_index = 0;
    while ((opt = getopt_long(argc, argv, "c:s:h", long_options, &option_index)) != -1) {
        switch (opt) {
            case 'c':
                strncpy(config.config_file, optarg, sizeof(config.config_file)-1);
                config.config_file[sizeof(config.config_file)-1] = '\0';
                printf("Config file: %s\n", config.config_file);
                break;
            case 's':
            {
                char *endptr;
                long val = strtol(optarg, &endptr, 10);
                if (endptr == optarg || *endptr != '\0' || val < 1) {
                    fprintf(stderr, "Invalid interval: %s\n", optarg);
                    fprintf(stderr, "Interval must be an integer >=1\n");
                    exit(EXIT_FAILURE);
                }
                sleep_interval = (int)val;
                printf("Sleep interval: %d s\n", sleep_interval);
                break;
            }
            case 'h':
                print_help(argv[0]);
                exit(EXIT_SUCCESS);
            default:
                print_help(argv[0]);
                exit(EXIT_FAILURE);
        }
    }

    ProcCache cache = {0};
    int config_counter = 9;
    int affinity_counter = 9;
    printf("Start AppOpt service.\n");

    for (;;) {
        config_counter++;
        if (config_counter > 3) {
            if (load_config(&config)) cache.last_proc_count = 0;
            config_counter = 0;
        }
        update_cache(&cache, &config, &affinity_counter);
        affinity_counter++;
        if (affinity_counter > 3) {
            apply_affinity(&cache, &config.topo);
            affinity_counter = 0;
        }
        sleep(sleep_interval);
    }
}