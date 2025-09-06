******************************************
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

# 美团外卖
com.sankuai.meituan.takeoutnew{RenderThread}=$(format_cpu_ranges "$hp_core") 
com.sankuai.meituan.takeoutnew{tuan.takeoutnew}=$(format_cpu_ranges "$p_core") 
com.sankuai.meituan.takeoutnew{J*}=$(format_cpu_ranges "$p_core") 
com.sankuai.meituan.takeoutnew=$(format_cpu_ranges "$e_core $p_core")

# 饿了么
me.ele{HeapTaskDaemon}=$(format_cpu_ranges "$p_core")
me.ele{me.ele}=$(format_cpu_ranges "$p_core")
me.ele{RenderThread}=$(format_cpu_ranges "$p_core")
me.ele{ODCP*}=$(format_cpu_ranges "$
$p_core")
me.ele{LWalle*}=$(format_cpu_ranges "$p_core")
me.ele{ReferenceQueueD}=$(format_cpu_ranges "$p_core")
me.ele=$(format_cpu_ranges "$e_core $p_core")

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

# 爱奇艺
com.qiyi.video{PLAYER_INFLATE_}=$(format_cpu_ranges "$p_core")
com.qiyi.video{RenderThread}=$(format_cpu_ranges "$p_core")
com.qiyi.video{DanmakuGLThread}=$(format_cpu_ranges "$p_core")
com.qiyi.video{com.qiyi.video}=$(format_cpu_ranges "$p_core")
com.qiyi.video{PumaPlyrVEgn}=$(format_cpu_ranges "$p_core")
com.qiyi.video=$(format_cpu_ranges "$e_core $p_core")

#抖音
com.ss.android.ugc.aweme{RenderThread}=$(format_cpu_ranges "$p_core")
com.ss.android.ugc.aweme{HeapTaskDaemon}=$(format_cpu_ranges "$p_core")
com.ss.android.ugc.aweme{danmaku-driver}=$(format_cpu_ranges "$p_core")
com.ss.android.ugc.aweme{VDecod2-*}=$(format_cpu_ranges "$p_core")
com.ss.android.ugc.aweme{droid.ugc.aweme}=$(format_cpu_ranges "$p_core")
com.ss.android.ugc.aweme{#pty-wqp-*}=2-4
com.ss.android.ugc.aweme=$(format_cpu_ranges "$e_core $p_core")

# 快手
com.smile.gifmaker{RenderThread}=$(format_cpu_ranges "$p_core") 
com.smile.gifmaker{smile.gifmaker}=$(format_cpu_ranges "$p_core") 
com.smile.gifmaker{MediaCodec_*}=$(format_cpu_ranges "$p_core") 
com.smile.gifmaker=$(format_cpu_ranges "$e_core $p_core")

#piliplus
com.example.piliplus{1.raster}=$(format_cpu_ranges "$p_core")
com.example.piliplus{Thread-*}=$(format_cpu_ranges "$p_core")
com.example.piliplus{1.ui}=$(format_cpu_ranges "$p_core")
com.example.piliplus=$(format_cpu_ranges "$e_core $p_core")

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