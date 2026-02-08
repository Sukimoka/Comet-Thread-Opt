MODDIR=${0%/*}

APP_LIST_URL="https://raw.githubusercontent.com/Sukimoka/Comet-Thread-Opt/main/app/App_common.txt"
CHANGELOG_URL="https://raw.githubusercontent.com/Sukimoka/Comet-Thread-Opt/main/ChangeLog.txt"
API_URL="https://api.github.com/repos/Sukimoka/Comet-Thread-Opt/commits?sha=main"
UPDATE_TIME=$(date +"%m月%d日%H:%M")

APPLIST_CONF="$MODDIR/applist.conf"
CPUINFO_FILE="$MODDIR/cpuinfo.txt"
TIME_FILE="$MODDIR/time.txt"

download_file() {
    local url="$1"
    local output="$2"

# 优先尝试 curl
    if command -v curl >/dev/null 2>&1; then
        if [ -z "$output" ]; then
            curl -sL --connect-timeout 10 "$url"
        else
            curl -sL --connect-timeout 10 "$url" -o "$output"
        fi
# 回退尝试 wget
    elif command -v wget >/dev/null 2>&1; then
        if [ -z "$output" ]; then
            wget -q -T 10 -O - "$url"
        else
            wget -q -T 10 -O "$output" "$url"
        fi
    else
# 两个都没有，返回错误
        return 1
    fi
}

TEMP_APP="$MODDIR/app.tmp"
# 错误后回退
download_file "$APP_LIST_URL" "$TEMP_APP"
# 检查是否下载成功
if [ ! -s "$TEMP_APP" ]; then
    echo "下载 App 线程配置失败"
    rm -f "$TEMP_APP"
    exit 1
fi

cat "$TEMP_APP" > "$APPLIST_CONF"
# 删除临时文件
rm -f "$TEMP_APP"

get_cpu_val() {
    local search_str="$1"
    # 查找包含字符串的行,取等号后面,删除换行符
    grep -F "$search_str" "$CPUINFO_FILE" | head -n 1 | cut -d= -f2 | tr -d '\r\n'
}

val_hp=$(get_cpu_val '(format_cpu_ranges "$hp_core")')
val_e=$(get_cpu_val '(format_cpu_ranges "$e_core")')
val_ep=$(get_cpu_val '(format_cpu_ranges "$e_core $p_core")')
val_p=$(get_cpu_val '(format_cpu_ranges "$p_core")')
val_ph=$(get_cpu_val '(format_cpu_ranges "$p_core $hp_core")')

sed -i \
    -e 's|\$(format_cpu_ranges "$hp_core")|'"$val_hp"'|g' \
    -e 's|\$(format_cpu_ranges "$e_core")|'"$val_e"'|g' \
    -e 's|\$(format_cpu_ranges "$e_core $p_core")|'"$val_ep"'|g' \
    -e 's|\$(format_cpu_ranges "$p_core")|'"$val_p"'|g' \
    -e 's|\$(format_cpu_ranges "$p_core $hp_core")|'"$val_ph"'|g' \
    "$APPLIST_CONF"
    
# 读取上次更新时间
if [ -f "$TIME_FILE" ]; then
    LAST_UPDATE=$(cat "$TIME_FILE" | sed 's/ UTC$//')
    SINCE_TIME=$(echo "$LAST_UPDATE" | sed 's/ /T/')Z
else
    LAST_UPDATE=""
    SINCE_TIME=""
fi

# 更新 module.prop 中的时间
sed -i "/^description=/ s/ 配置时间.*$//" "$MODDIR/module.prop"
sed -i "/^description=/ s/$/ 配置时间$UPDATE_TIME/" "$MODDIR/module.prop"
UTC_TIME=$(date -u +"%Y-%m-%d %H:%M:%S")
echo "$UTC_TIME UTC" > "$TIME_FILE"

echo "-------------------------------------"
echo "已成功更新 applist"
echo "-------------------------------------"
echo "📝 更新内容:"

# 获取并解析日志
export PATH="${PATH}:/data/adb/magisk:/data/adb/ksu/bin:/data/adb/ap/bin"
[ "$(which -a busybox)" != "" ] && alias grep="busybox grep"
[ "$(which -a busybox)" != "" ] && alias sed="busybox sed"

# 构建API URL,如果有上次更新时间则添加since参数
if [ -n "$SINCE_TIME" ]; then
    FETCH_URL="${API_URL}&since=${SINCE_TIME}"
else
    FETCH_URL="$API_URL"
fi

# 获取新提交
NEW_COMMITS=$(curl -skLA "Mozilla/5.0" "$FETCH_URL" | grep -Eo '"message":"[^"]*"' | sed 's/"message":"//;s/"//g' | grep -E "(App)\:")

if [ -n "$NEW_COMMITS" ]; then
    echo "$NEW_COMMITS" | head -n 6
else
    echo "暂无新更新"
fi

echo "${message}"
echo "-------------------------------------"
echo "🎉 配置更新完成"

sleep 2