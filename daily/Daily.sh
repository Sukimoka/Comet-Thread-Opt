SKIPUNZIP=0
check_magisk_version() {
	ui_print "- Magisk version: $MAGISK_VER_CODE"
	ui_print "- Module version: $(grep_prop version "${TMPDIR}/module.prop")"
	ui_print "- Module versionCode: $(grep_prop versionCode "${TMPDIR}/module.prop")"
	ui_print "********************************************"
	ui_print "- $(grep_prop description "${TMPDIR}/module.prop")"
	if [ "$MAGISK_VER_CODE" -lt 20400 ]; then
		ui_print "********************************************"
		ui_print "! 请安装 Magisk v20.4+ (20400+)"
		abort    "********************************************"
	fi
}
check_required_files() {
	REQUIRED_FILE_LIST="/sys/devices/system/cpu/present /proc/loadavg"
	for REQUIRED_FILE in $REQUIRED_FILE_LIST; do
		if [ ! -e $REQUIRED_FILE ]; then
			ui_print "********************************************"
			ui_print "! $REQUIRED_FILE 文件不存在"
			ui_print "! 请联系模块作者"
			abort    "********************************************"
		fi
	done
}
extract_bin() {
	ui_print "********************************************"
	if [ "$ARCH" == "arm" ]; then
		cp $MODPATH/bin/armeabi-v7a/AppOpt $MODPATH
	elif [ "$ARCH" == "arm64" ]; then
		cp $MODPATH/bin/arm64-v8a/AppOpt $MODPATH
	elif [ "$ARCH" == "x86" ]; then
		cp $MODPATH/bin/x86/AppOpt $MODPATH
	elif [ "$ARCH" == "x64" ]; then
		cp $MODPATH/bin/x86_64/AppOpt -v $MODPATH
	else
		abort "! Unsupported platform: $ARCH"
	fi
	ui_print "- Device platform: $ARCH"
	rm -rf $MODPATH/bin
	[ -f $MODPATH/AppOpt ] && chmod a+x $MODPATH/AppOpt
	if ! $MODPATH/AppOpt -v; then
		abort "! 主程序验证失败，请检查模块zip文件是否损坏"
	fi
}
remove_sys_perf_config() {
	for SYSPERFCONFIG in $(ls /system/vendor/bin/msm_irqbalance); do
		[[ ! -d $MODPATH${SYSPERFCONFIG%/*} ]] && mkdir -p $MODPATH${SYSPERFCONFIG%/*}
		ui_print "- Remove :$SYSPERFCONFIG"
		touch $MODPATH$SYSPERFCONFIG
	done
	if [ -n "$(pm path com.xiaomi.joyose)" ] && [ -n "$(getprop ro.miui.ui.version.code)" ]; then
		pm disable --user 0 com.xiaomi.joyose/.smartop.SmartOpService
		echo 'pm enable com.xiaomi.joyose/.smartop.SmartOpService' >> $MODPATH/uninstall.sh
	fi
}
format_cpu_ranges() {
	[ -z "${1// /}" ] && { cat /sys/devices/system/cpu/present; return; }
	awk -v input="$1" 'BEGIN {
		n = split(input, arr, /[[:space:]]+/)
		j = 0
		for (i = 1; i <= n; i++) {
			if (arr[i] != "" && !seen[arr[i]]++) 
				nums[++j] = arr[i] + 0
		}
		n = j
		if (!n) exit
		for (i = 1; i < n; i++) {
			min = i
			for (j = i + 1; j <= n; j++)
				if (nums[j] < nums[min]) min = j
			if (min != i) {
				t = nums[i]
				nums[i] = nums[min]
				nums[min] = t
			}
		}
		start = last = nums[1]
		for (i = 2; i <= n; i++) {
			if (nums[i] == last + 1) {
				last = nums[i]
				continue
			}
			printf "%s%s", sep, (start == last ? start : start "-" last)
			sep = ","
			start = last = nums[i]
		}
		printf "%s", sep
		printf (start == last ? start : start "-" last)
	}'
}
sorted_groups=$(
	for policy in /sys/devices/system/cpu/cpufreq/policy*; do
		[ -d "$policy" ] || continue
		cpus=$(cat "$policy/related_cpus" 2>/dev/null)
		freq=$(cat "$policy/cpuinfo_max_freq" 2>/dev/null)
		[ -z "$cpus" ] || [ -z "$freq" ] && continue
		echo "$freq:$cpus"
	done | sort -n -t: -k1,1 | awk -F: '
	$1 == prev { cores = cores " " $2; next }
	prev != "" { print prev ":" cores; cores = "" }
	{ prev = $1; cores = $2 }
	END { if (prev != "") print prev ":" cores }'
)
eval "$(echo "$sorted_groups" | awk -F: '
BEGIN {
	e_core = ""; p_core = ""; hp_core = ""
	e_core_freq = 0; p_core_freq = 0; hp_core_freq = 0
	total_groups = 0
}
{
	freq_arr[NR] = $1
	cpus_arr[NR] = $2
	total_groups = NR
}
END {
	if (total_groups == 0) {
		print "e_core=\"\"; e_core_freq=0; p_core=\"\"; p_core_freq=0; hp_core=\"\"; hp_core_freq=0; total_groups=0;"
		exit
	}
	e_core = cpus_arr[1]
	e_core_freq = freq_arr[1]
	if (total_groups >= 2) {
		hp_core = cpus_arr[total_groups]
		hp_core_freq = freq_arr[total_groups]
	}
	if (total_groups >= 3) {
		p_core = ""
		p_core_freq = 0
		for (i = 2; i < total_groups; i++) {
			p_core = p_core (p_core == "" ? "" : " ") cpus_arr[i]
			if (freq_arr[i] > p_core_freq) p_core_freq = freq_arr[i]
		}
	}
	printf "e_core=\"%s\"; e_core_freq=%d; ", e_core, e_core_freq
	printf "p_core=\"%s\"; p_core_freq=%d; ", p_core, p_core_freq
	printf "hp_core=\"%s\"; hp_core_freq=%d; ", hp_core, hp_core_freq
	printf "total_groups=%d;", total_groups
}')"
all_core="$(cat /sys/devices/system/cpu/present)"
module_instructions() {
	ui_print "********************************************"
	ui_print "线程规则配置文件路径为："
	ui_print "/data/adb/modules/AppOpt/applist.conf"
	ui_print "------------------------------------------"
	ui_print "修改与添加规则无需重启，即时生效"
	ui_print "********************************************"
	cores=$(for cpus in /sys/devices/system/cpu/cpufreq/*/related_cpus; do 
		[ -f "$cpus" ] && cat "$cpus" | wc -w
	done | paste -sd+)
	ui_print "当前$(getprop ro.soc.model)设备为$(nproc)核CPU，规格是：$cores"
	ui_print "可用CPU范围：$all_core"
	ui_print "------------------------------------------"
	[ -n "$(format_cpu_ranges "$e_core")" ] && echo "$(format_cpu_ranges "$e_core") 为能效小核，频率最高$((e_core_freq/1000)) MHz"
	[ $total_groups -ge 3 ] && [ -n "$(format_cpu_ranges "$p_core")" ] && echo "$(format_cpu_ranges "$p_core") 为性能中核，频率最高$((p_core_freq/1000)) MHz"
	[ $total_groups -ge 2 ] && [ -n "$(format_cpu_ranges "$hp_core")" ] && echo "$(format_cpu_ranges "$hp_core") 为高性能大核，频率最高$((hp_core_freq/1000)) MHz"
	ui_print "------------------------------------------"
	ui_print "applist.conf 规则写法示例："
	ui_print "------------------------------------------"
	if [ -n "$all_core" ]; then
		ui_print "允许安卓 '图形显示组件 '调用所有核心："
		ui_print "surfaceflinger=$all_core"
		ui_print "------------------------------------------"
	fi
	if [ -n "$(format_cpu_ranges "$hp_core")" ]; then
		ui_print "单独将'图形显示组件'渲染引擎线程绑定到大核："
		ui_print "surfaceflinger{RenderEngine}=$(format_cpu_ranges "$hp_core")"
		ui_print "------------------------------------------"
	fi
	if [ -n "$(format_cpu_ranges "$e_core")" ]; then
		ui_print "将 '微信' 主进程绑定能效小核："
		ui_print "com.tencent.mm=$(format_cpu_ranges "$e_core")"
		ui_print "------------------------------------------"
	fi
	if [ -n "$(format_cpu_ranges "$e_core")" ]; then
		ui_print "将 '微信' 消息推送子进程绑定能效小核："
		ui_print "com.tencent.mm:push=$(format_cpu_ranges "$e_core")"
		ui_print "------------------------------------------"
	fi
	if [ -n "$(format_cpu_ranges "$hp_core")" ]; then
		ui_print "将 '系统界面' 渲染线程绑定到性能大核："
		ui_print "com.android.systemui{RenderThread}=$(format_cpu_ranges "$hp_core")"
		ui_print "------------------------------------------"
	fi
	ui_print "更多规则使用说明请参考："
	ui_print "http://AppOpt.suto.top"
	ui_print "********************************************"
}
add_default_rules() {
# format_cpu_ranges函数用法：
# $(format_cpu_ranges "$e_core")           表示能效小核
# $(format_cpu_ranges "$p_core")           表示性能中核
# $(format_cpu_ranges "$hp_core")          为高性能大核
# 也可以组合一起用：
# $(format_cpu_ranges "$e_core $p_core")  为小核与中核
# $(format_cpu_ranges "$p_core $hp_core") 为中核与大核

common_rules="
#系统桌面
com.android.launcher=$(format_cpu_ranges "$e_core $p_core")
com.android.launcher{RenderThread}=$(format_cpu_ranges "$p_core") 
com.android.launcher{binder*}=$(format_cpu_ranges "$p_core") 
com.android.launcher{ndroid.launcher}=$(format_cpu_ranges "$p_core") 

#pixel启动器
com.google.android.apps.nexuslauncher=$(format_cpu_ranges "$e_core $p_core")
com.google.android.apps.nexuslauncher{RenderThread}=$(format_cpu_ranges "$p_core") 
com.google.android.apps.nexuslauncher{s.nexuslauncher}=$(format_cpu_ranges "$p_core") 
com.google.android.apps.nexuslauncher{binder*}=$(format_cpu_ranges "$p_core") 

#通讯
# 微信
com.tencent.mm=$(format_cpu_ranges  "$e_core $p_core")
com.tencent.mm{com.tencent.mm}=$(format_cpu_ranges "$p_core") 
com.tencent.mm{default_matrix_}=$(format_cpu_ranges "$p_core") 
com.tencent.mm{binder:*}=$(format_cpu_ranges "$p_core") 

# QQ
com.tencent.mobileqq=$(format_cpu_ranges "$e_core $p_core")
com.tencent.mobileqq{encent.mobileqq}=$(format_cpu_ranges "$p_core") 
com.tencent.mobileqq{RenderThread}=$(format_cpu_ranges "$p_core") 
com.tencent.mobileqq{MediaCodec_loop}=$(format_cpu_ranges "$p_core") 

# Nekogram
tw.nekomimi.nekogram{files_database_}=$(format_cpu_ranges "$p_core") <
tw.nekomimi.nekogram{searchQueue}=$(format_cpu_ranges "$p_core") 
tw.nekomimi.nekogram{komimi.nekogram}=$(format_cpu_ranges "$p_core") 
tw.nekomimi.nekogram{RehderThread}=$(format_cpu_ranges "$p_core") 
tw.nekomimi.nekogram=$(format_cpu_ranges "$e_core $p_core")

# telegram
org.telegram.group{RenderThread}=$(format_cpu_ranges "$p_core") 
org.telegram.group{.telegram.group}=$(format_cpu_ranges "$p_core") 
org.telegram.group{Thread-*}=$(format_cpu_ranges "$p_core") 
org.telegram.group=$(format_cpu_ranges "$e_core $p_core")

# Nagram X
nu.gpu.nagram{nu.gpu.nagram}=$(format_cpu_ranges "$p_core") 
nu.gpu.nagram{RenderThread}=$(format_cpu_ranges "$p_core") 
nu.gpu.nagram{Thread-*}=$(format_cpu_ranges "$p_core") 
nu.gpu.nagram=$(format_cpu_ranges "$e_core $p_core")

# 钉钉
com.alibaba.android.rimet={a.android.rimet}=$(format_cpu_ranges "$p_core") 
com.alibaba.android.rimet={RenderThread}=$(format_cpu_ranges "$p_core") 
com.alibaba.android.rimet={Doraemon-Proces}=$(format_cpu_ranges "$p_core") 
com.alibaba.android.rimet=$(format_cpu_ranges "$e_core $p_core")

#购物
# 淘宝
com.taobao.taobao{WeexJSBridgeTh}=$(format_cpu_ranges "$p_core")
com.taobao.taobao{HeapTaskDaemon}=$(format_cpu_ranges "$p_core")
com.taobao.taobao{m.taobao.taobao}=$(format_cpu_ranges "$p_core")
com.taobao.taobao{8RYPVI8EZKhJUU}=$(format_cpu_ranges "$p_core")
com.taobao.taobao=$(format_cpu_ranges "$e_core $p_core")

# 京东
com.jingdong.app.mall{RunnerWrapper_8}=$(format_cpu_ranges "$p_core") 
com.jingdong.app.mall{ngdong.app.mall}=$(format_cpu_ranges "$p_core") 
com.jingdong.app.mall{pool-15-thread-}=$(format_cpu_ranges "$p_core") 
com.jingdong.app.mall{JDFileDownloade}=$(format_cpu_ranges "$p_core") 
com.jingdong.app.mall{RenderThread}=$(format_cpu_ranges "$p_core") 
com.jingdong.app.mall=$(format_cpu_ranges "$e_core $p_core")


# 拼多多
com.xunmeng.pinduoduo{Chat#Single-Syn}=$(format_cpu_ranges "$p_core") 
com.xunmeng.pinduoduo{Startup#RTDispa}=$(format_cpu_ranges "$p_core") 
com.xunmeng.pinduoduo{nmeng.pinduoduo}=$(format_cpu_ranges "$p_core") 
com.xunmeng.pinduoduo{RenderThread}=$(format_cpu_ranges "$p_core") 
com.xunmeng.pinduoduo{Jit thread pool}=$(format_cpu_ranges "$p_core") 
com.xunmeng.pinduoduo=$(format_cpu_ranges "$e_core $p_core")

# 闲鱼
com.taobao.idlefish{RenderThread}=$(format_cpu_ranges "$p_core") 
com.taobao.idlefish{1.ui}=$(format_cpu_ranges "$p_core") 
com.taobao.idlefish{taobao.idlefish}=$(format_cpu_ranges "$p_core") 
com.taobao.idlefish{1.raster}=$(format_cpu_ranges "$p_core") 
com.taobao.idlefish=$(format_cpu_ranges "$e_core $p_core")

# 美团
com.sankuai.meituan{RenderThread}=$(format_cpu_ranges "$p_core") 
com.sankuai.meituan{sankuai.meituan}=$(format_cpu_ranges "$p_core") 
com.sankuai.meituan{TTE-keyAgreemen}=$(format_cpu_ranges "$p_core") 
com.sankuai.meituan=$(format_cpu_ranges "$e_core $p_core")

# 支付宝
com.eg.android.AlipayGphone=$(format_cpu_ranges "$e_core $p_core")
com.eg.android.AlipayGphone{crv-worker-thre}=$(format_cpu_ranges "$p_core") 
com.eg.android.AlipayGphone{id.AlipayGphone}=$(format_cpu_ranges "$p_core") 
com.eg.android.AlipayGphone{RenderThread}=$(format_cpu_ranges "$p_core") 

#娱乐社媒
# 哔哩哔哩
tv.danmaku.bili=$(format_cpu_ranges "$e_core $p_core")
tv.danmaku.bili{tv.danmaku.bili}=$(format_cpu_ranges "$p_core") 
tv.danmaku.bili{RenderThread}=$(format_cpu_ranges "$p_core") 
tv.danmaku.bili{Thread-*}=$(format_cpu_ranges "$p_core") 
tv.danmaku.bili{IJK_External_Re}=$(format_cpu_ranges "$p_core") 

# 酷安
com.coolapk.market=$(format_cpu_ranges "$e_core $p_core")
com.coolapk.market{RenderThread}=$(format_cpu_ranges "$p_core") 
com.coolapk.market{.coolapk.market}=$(format_cpu_ranges "$p_core") 
com.coolapk.market{Thread-*}=$(format_cpu_ranges "$p_core") 
com.coolapk.market{binder:*}=$(format_cpu_ranges "$p_core") 

# 微博
com.sina.weibo{com.sina.weibo}=$(format_cpu_ranges "$p_core") 
com.sina.weibo{RenderThread}=$(format_cpu_ranges "$p_core") 
com.sina.weibo{Thread-*}=$(format_cpu_ranges "$p_core") 
com.sina.weibo=$(format_cpu_ranges "$e_core $p_core")

# X
com.twitter.android{RenderThread}=$(format_cpu_ranges "$p_core") 
com.twitter.android{twitter.android}=$(format_cpu_ranges "$p_core") 
com.twitter.android{binder*}=$(format_cpu_ranges "$p_core") 
com.twitter.android=$(format_cpu_ranges "$e_core $p_core")

# 快手
com.smile.gifmaker{RenderThread}=$(format_cpu_ranges "$p_core") 
com.smile.gifmaker{smile.gifmaker}=$(format_cpu_ranges "$p_core") 
com.smile.gifmaker{MediaCodec_*}=$(format_cpu_ranges "$p_core") 
com.smile.gifmaker=$(format_cpu_ranges "$e_core $p_core")

# 网易云音乐
com.netease.cloudmusic{RenderThread}=$(format_cpu_ranges "$p_core") 
com.netease.cloudmusic{ease.cloudmusic}=$(format_cpu_ranges "$p_core") 
com.netease.cloudmusic{LooperTracer}
com.netease.cloudmusic=$(format_cpu_ranges "$e_core $p_core")

# Lanerc
com.xuzly.hy.lanerc.app{1.ui}=$(format_cpu_ranges "$p_core") 
com.xuzly.hy.lanerc.app{mpv/demux}=$(format_cpu_ranges "$p_core") 
com.xuzly.hy.lanerc.app{1.raster}=$(format_cpu_ranges "$p_core") 
com.xuzly.hy.lanerc.app{Thread-*}=$(format_cpu_ranges "$p_core") 
com.xuzly.hy.lanerc.app=$(format_cpu_ranges "$e_core $p_core")

#地图
# 高德地图  
com.autonavi.minimap{AJXBizCheck}=$(format_cpu_ranges "$p_core") 
com.autonavi.minimap{JavaScriptThrea}=$(format_cpu_ranges "$p_core") 
com.autonavi.minimap{Map-Logical-0}=$(format_cpu_ranges "$p_core") 
com.autonavi.minimap{utonavi.minimap}=$(format_cpu_ranges "$p_core") 
com.autonavi.minimap=$(format_cpu_ranges "$e_core $p_core")

# 百度地图  
com.baidu.BaiduMap{31.1_0223536945}=$(format_cpu_ranges "$p_core") 
com.baidu.BaiduMap{.31.1_062565145}=$(format_cpu_ranges "$p_core")
com.baidu.BaiduMap{.baidu.BaiduMap}=$(format_cpu_ranges "$p_core")
com.baidu.BaiduMap{*Thread}=$(format_cpu_ranges "$p_core")
com.baidu.BaiduMap=$(format_cpu_ranges "$e_core $p_core")

# 将 'Android图形显示组件'渲染引擎线程绑定到大核
surfaceflinger{RenderEngine}=$(format_cpu_ranges "$hp_core")

# 允许 'Android图形显示组件' 使用所有CPU核心$all_core
surfaceflinger=$all_core

# 将 '系统界面' 渲染引擎线程与主线程绑定到中大核
com.android.systemui{RenderThread}=$(format_cpu_ranges "$hp_core")
com.android.systemui{ndroid.systemui}=$(format_cpu_ranges "$p_core $hp_core")
"

echo "$common_rules" >> $MODPATH/applist.conf
echo "$game_rules" >> $MODPATH/applist.conf
if [ -f /data/adb/modules/AppOpt/applist.conf ]; then
	mv $MODPATH/applist.conf $MODPATH/applist.conf.bak
	cp -r /data/adb/modules/AppOpt/applist.conf $MODPATH
fi
}
check_magisk_version
check_required_files
extract_bin
remove_sys_perf_config
module_instructions
add_default_rules
set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm_recursive "$MODPATH/*.sh $MODPATH/AppOpt" 0 2000 0755 0755 u:object_r:magisk_file:s0
