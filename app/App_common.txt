"******************************************""
common_rules="
#通讯
# 微信
com.tencent.mm{RenderThread}=$(format_cpu_ranges "$p_core")
com.tencent.mm{com.tencent.mm}=$(format_cpu_ranges "$p_core")
com.tencent.mm{default_matrix_}=$(format_cpu_ranges "$p_core")
com.tencent.mm{binder:*}=$(format_cpu_ranges "$p_core")
com.tencent.mm=$(format_cpu_ranges "$e_core $p_core")

# QQ
com.tencent.mobileqq{RenderThread}=$(format_cpu_ranges "$p_core")
com.tencent.mobileqq{MediaCodec_loop}=$(format_cpu_ranges "$p_core")
com.tencent.mobileqq{encent.mobileqq}=$(format_cpu_ranges "$p_core")
com.tencent.mobileqq=$(format_cpu_ranges "$e_core $p_core")

# TIM
com.tencent.tim{com.tencent.tim}=$(format_cpu_ranges "$p_core")
com.tencent.tim{RenderThread}=$(format_cpu_ranges "$p_core")
com.tencent.tim{HeapTaskDaemon}=$(format_cpu_ranges "$p_core")
com.tencent.tim=$(format_cpu_ranges "$e_core $p_core")

# Nekogram
tw.nekomimi.nekogram{RehderThread}=$(format_cpu_ranges "$p_core")
tw.nekomimi.nekogram{files_database_}=$(format_cpu_ranges "$p_core")
tw.nekomimi.nekogram{searchQueue}$(format_cpu_ranges "$p_core")
tw.nekomimi.nekogram{komimi.nekogram}=$(format_cpu_ranges "$p_core")
tw.nekomimi.nekogram=$(format_cpu_ranges "$e_core $p_core")

# telegram
org.telegram.group{Thread-*}=$(format_cpu_ranges "$p_core")
org.telegram.group{RenderThread}=$(format_cpu_ranges "$p_core")
org.telegram.group{.telegram.group}=$(format_cpu_ranges "$p_core")
org.telegram.group=$(format_cpu_ranges "$e_core $p_core")
org.telegram.messenger{Thread-*}=$(format_cpu_ranges "$p_core")
org.telegram.messenger{RenderThread}=$(format_cpu_ranges "$p_core")
org.telegram.messenger{egram.messenger}=$(format_cpu_ranges "$p_core")
org.telegram.messenger=$(format_cpu_ranges "$e_core $p_core")

# Nagram X
nu.gpu.nagram{Thread-*}=$(format_cpu_ranges "$p_core")
nu.gpu.nagram{RenderThread}=$(format_cpu_ranges "$p_core")
nu.gpu.nagram{nu.gpu.nagram}=$(format_cpu_ranges "$p_core")
nu.gpu.nagram=$(format_cpu_ranges "$e_core $p_core")

# Ayugram
com.radolyn.ayugram{RenderThread}=$(format_cpu_ranges "$p_core")
com.radolyn.ayugram{radolyn.ayugram}=$(format_cpu_ranges "$p_core")
com.radolyn.ayugram{SpoilerEffectBi}=$(format_cpu_ranges "$p_core")
com.radolyn.ayugram{Thread-*}=$(format_cpu_ranges "$p_core")
com.radolyn.ayugram=$(format_cpu_ranges "$e_core $p_core")

# 钉钉
com.alibaba.android.rimet{RenderThread}=$(format_cpu_ranges "$p_core")
com.alibaba.android.rimet{a.android.rimet}=$(format_cpu_ranges "$p_core")
com.alibaba.android.rimet{Doraemon-Proces}=$(format_cpu_ranges "$p_core")
com.alibaba.android.rimet=$(format_cpu_ranges "$e_core $p_core")

#购物
# 淘宝
com.taobao.taobao{WeexJSBridgeTh}=$(format_cpu_ranges "$p_core")
com.taobao.taobao{HeapTaskDaemon}=$(format_cpu_ranges "$p_core")
com.taobao.taobao{m.taobao.taobao}=$(format_cpu_ranges "$p_core")
com.taobao.taobao{8RYPVI8EZKhJUU}=$(format_cpu_ranges "$p_core")
com.taobao.taobao=$(format_cpu_ranges "$e_core $p_core")

# 京东
com.jingdong.app.mall{RenderThread}=$(format_cpu_ranges "$p_core")
com.jingdong.app.mall{pool-15-thread-}=$(format_cpu_ranges "$p_core")
com.jingdong.app.mall{RunnerWrapper_8}=$(format_cpu_ranges "$p_core")
com.jingdong.app.mall{ngdong.app.mall}=$(format_cpu_ranges "$p_core")
com.jingdong.app.mall{JDFileDownloade}=$(format_cpu_ranges "$p_core")
com.jingdong.app.mall=$(format_cpu_ranges "$e_core $p_core")

# 拼多多
com.xunmeng.pinduoduo{RenderThread}=$(format_cpu_ranges "$p_core")
com.xunmeng.pinduoduo{Chat#Single-Syn}=$(format_cpu_ranges "$p_core")
com.xunmeng.pinduoduo{Startup#RTDispa}=$(format_cpu_ranges "$p_core")
com.xunmeng.pinduoduo{nmeng.pinduoduo}=$(format_cpu_ranges "$p_core")
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
com.eg.android.AlipayGphone{RenderThread}=$(format_cpu_ranges "$p_core")
com.eg.android.AlipayGphone{crv-worker-thre}=$(format_cpu_ranges "$p_core")
com.eg.android.AlipayGphone{id.AlipayGphone}=$(format_cpu_ranges "$p_core")
com.eg.android.AlipayGphone=$(format_cpu_ranges "$e_core $p_core")

# 美团外卖
com.sankuai.meituan.takeoutnew{RenderThread}=$(format_cpu_ranges "$p_core")
com.sankuai.meituan.takeoutnew{tuan.takeoutnew}=$(format_cpu_ranges "$p_core")
com.sankuai.meituan.takeoutnew{J*}=$(format_cpu_ranges "$p_core")
com.sankuai.meituan.takeoutnew=$(format_cpu_ranges "$e_core $p_core")

# 饿了么
me.ele{me.ele}=$(format_cpu_ranges "$hp_core")
me.ele{dp2ndk}=$(format_cpu_ranges "$p_core")
me.ele{Xxdn-Worker}=$(format_cpu_ranges "$p_core")
me.ele{1.raster}=$(format_cpu_ranges "$p_core")
me.ele{2.raster}=$(format_cpu_ranges "$p_core")
me.ele=$(format_cpu_ranges "$e_core $p_core")

#娱乐社媒
# 哔哩哔哩
tv.danmaku.bili{RenderThread}=$(format_cpu_ranges "$p_core")
tv.danmaku.bili{Thread*}=$(format_cpu_ranges "$p_core")
tv.danmaku.bili{IJK_External_Re}=$(format_cpu_ranges "$p_core")
tv.danmaku.bili{tv.danmaku.bili}=$(format_cpu_ranges "$p_core")
tv.danmaku.bili{MediaCodec_loop}=$(format_cpu_ranges "$p_core")
tv.danmaku.bili=$(format_cpu_ranges "$e_core $p_core")

# 哔哩哔哩Play
com.bilibili.app.in{RenderThread}=$(format_cpu_ranges "$p_core")
com.bilibili.app.in{Thread*}=$(format_cpu_ranges "$p_core")
com.bilibili.app.in{IJK_External_Re}=$(format_cpu_ranges "$p_core")
com.bilibili.app.in{*.app.in}=$(format_cpu_ranges "$p_core")
com.bilibili.app.in{MediaCodec_loop}=$(format_cpu_ranges "$p_core")
com.bilibili.app.in=$(format_cpu_ranges "$e_core $p_core")

# piliplus
com.example.piliplus{Thread-*}=$(format_cpu_ranges "$p_core")
com.example.piliplus{1.raster}=$(format_cpu_ranges "$p_core")
com.example.piliplus{1.ui}=$(format_cpu_ranges "$p_core")
com.example.piliplus=$(format_cpu_ranges "$e_core $p_core")

# komikku
app.komikku.beta{pp.komikku.beta}=$(format_cpu_ranges "$p_core")
app.komikku.beta{*thread*}=$(format_cpu_ranges "$p_core")
app.komikku.beta{RenderThread}=$(format_cpu_ranges "$p_core")
app.komikku.beta{AsyncTask*}=$(format_cpu_ranges "$p_core")
app.komikku.beta{}=$(format_cpu_ranges "$e_core $p_core")

# 快手
com.smile.gifmaker{RenderThread}=$(format_cpu_ranges "$p_core")
com.smile.gifmaker{smile.gifmaker}=$(format_cpu_ranges "$p_core")
com.smile.gifmaker{MediaCodec_*}=$(format_cpu_ranges "$p_core")
com.smile.gifmaker=$(format_cpu_ranges "$e_core $p_core")

# 快手极速版
com.kuaishou.nebula{RenderThread}=$(format_cpu_ranges "$p_core")
com.kuaishou.nebula{kuaishou.nebula}=$(format_cpu_ranges "$p_core")
com.kuaishou.nebula{thread*}=$(format_cpu_ranges "$p_core")
com.kuaishou.nebula{*ffmpeg*}=$(format_cpu_ranges "$p_core")
com.kuaishou.nebula=$(format_cpu_ranges "$e_core $p_core")

# 爱奇艺
com.qiyi.video{PLAYER_INFLATE_}=$(format_cpu_ranges "$p_core")
com.qiyi.video{RenderThread}=$(format_cpu_ranges "$p_core")
com.qiyi.video{DanmakuGLThread}=$(format_cpu_ranges "$p_core")
com.qiyi.video{com.qiyi.video}=$(format_cpu_ranges "$p_core")
com.qiyi.video{PumaPlyrVEgn}=$(format_cpu_ranges "$p_core")
com.qiyi.video=$(format_cpu_ranges "$e_core $p_core")

# 抖音 
com.ss.android.ugc.aweme{*Thread}=$(format_cpu_ranges "$p_core")
com.ss.android.ugc.aweme{VDecod2-*}=$(format_cpu_ranges "$p_core")
com.ss.android.ugc.aweme{HeapTaskDaemon}=$(format_cpu_ranges "$p_core")
com.ss.android.ugc.aweme{danmaku-driver}=$(format_cpu_ranges "$p_core")
com.ss.android.ugc.aweme{droid.ugc.aweme}=$(format_cpu_ranges "$p_core")
com.ss.android.ugc.aweme{#pty-wqp-*}=$(format_cpu_ranges "$p_core")
com.ss.android.ugc.aweme=$(format_cpu_ranges "$e_core $p_core")

# 酷安
com.coolapk.market{RenderThread}=$(format_cpu_ranges "$p_core")
com.coolapk.market{Thread-*}=$(format_cpu_ranges "$p_core")
com.coolapk.market{binder:*}=$(format_cpu_ranges "$p_core")
com.coolapk.market{.coolapk.market}=$(format_cpu_ranges "$p_core")
com.coolapk.market=$(format_cpu_ranges "$e_core $p_core")

# 微博
com.sina.weibo{RenderThread}=$(format_cpu_ranges "$p_core")
com.sina.weibo{Thread-*}=$(format_cpu_ranges "$p_core")
com.sina.weibo{com.sina.weibo}=$(format_cpu_ranges "$p_core")
com.sina.weibo=$(format_cpu_ranges "$e_core $p_core")

# 贴吧
com.baidu.tieba{RenderThread}=$(format_cpu_ranges "$p_core")
com.baidu.tieba{com.baidu.tieba}=$(format_cpu_ranges "$p_core")
com.baidu.tieba=$(format_cpu_ranges "$e_core $p_core")

# 知乎
com.zhihu.android{RenderThread}=$(format_cpu_ranges "$p_core")
com.zhihu.android{m.zhihu.android}=$(format_cpu_ranges "$p_core")
com.zhihu.android=$(format_cpu_ranges "$e_core $p_core")

# 悠悠有品
com.uu898.uuhavequality:core{8.uuhavequality}=$(format_cpu_ranges "$p_core")
com.uu898.uuhavequality:core{RenderThread}=$(format_cpu_ranges "$p_core")
com.uu898.uuhavequality:core{BR-LagTrace-Thr}=$(format_cpu_ranges "$p_core")
com.uu898.uuhavequality:core=$(format_cpu_ranges "$e_core $p_core")

# X
com.twitter.android{twitter.android}=$(format_cpu_ranges "$p_core")
com.twitter.android{RenderThread}=$(format_cpu_ranges "$p_core")
com.twitter.android{MediaCodec loop}=$(format_cpu_ranges "$p_core")
com.twitter.android=$(format_cpu_ranges "$e_core $p_core")

# YouTube
com.google.android.youtube{android.youtube}=$(format_cpu_ranges "$p_core")
com.google.android.youtube{RenderThread}=$(format_cpu_ranges "$p_core")
com.google.android.youtube{ExoPlayer:Playb}=$(format_cpu_ranges "$p_core")
com.google.android.youtube{MediaCodec loop}=$(format_cpu_ranges "$p_core")
com.google.android.youtube=$(format_cpu_ranges "$e_core $p_core")

# Facebook
com.facebook.katana{facebook.katana}=$(format_cpu_ranges "$p_core")
com.facebook.katana{RenderThread}=$(format_cpu_ranges "$p_core")
com.facebook.katana{ComponentLavout}=$(format_cpu_ranges "$p_core")
com.facebook.katana=$(format_cpu_ranges "$e_core $p_core")

# Discord
com.discord{com.discord}=$(format_cpu_ranges "$p_core")
com.discord{pool-10-thread-*}=$(format_cpu_ranges "$p_core")
com.discord{RenderThread}=$(format_cpu_ranges "$p_core")
com.discord{mqt js}=$(format_cpu_ranges "$p_core")
com.discord=$(format_cpu_ranges "$e_core $p_core")

# Lanerc
com.xuzly.hy.lanerc.app{Thread-*}=$(format_cpu_ranges "$p_core")
com.xuzly.hy.lanerc.app{1.ui}=$(format_cpu_ranges "$p_core")
com.xuzly.hy.lanerc.app{mpv/demux}=$(format_cpu_ranges "$p_core")
com.xuzly.hy.lanerc.app{1.raster}=$(format_cpu_ranges "$p_core")
com.xuzly.hy.lanerc.app=$(format_cpu_ranges "$e_core $p_core")

# 网易云音乐
com.netease.cloudmusic{RenderThread}=$(format_cpu_ranges "$p_core")
com.netease.cloudmusic{ease.cloudmusic}=$(format_cpu_ranges "$p_core")
com.netease.cloudmusic{LooperTracer}=$(format_cpu_ranges "$p_core")
com.netease.cloudmusic=$(format_cpu_ranges "$e_core $p_core")

# 酷狗概念版
com.kugou.android.lite{ou.android.lite}=$(format_cpu_ranges "$p_core")
com.kugou.android.lite{RenderThread}=$(format_cpu_ranges "$p_core")
com.kugou.android.lite=$(format_cpu_ranges "$e_core $p_core")

# 汽水音乐
com.luna.music{*.music}=$(format_cpu_ranges "$p_core")
com.luna.music{RenderThread}=$(format_cpu_ranges "$p_core")
com.luna.music=$(format_cpu_ranges "$e_core $p_core")

# Salt Player
com.salt.music{com.salt.music}=$(format_cpu_ranges "$p_core")
com.salt.music{RenderThread}=$(format_cpu_ranges "$p_core")
com.salt.music=$(format_cpu_ranges "$e_core $p_core")

# 喜马拉雅
com.ximalaya.ting.android{ya.ting.android}=$(format_cpu_ranges "$p_core")
com.ximalaya.ting.android{RenderThread}=$(format_cpu_ranges "$p_core")
com.ximalaya.ting.android=$(format_cpu_ranges "$e_core $p_core")

# Apple Music
com.apple.android.music{*.music}=$(format_cpu_ranges "$p_core")
com.apple.android.music{RenderThread}=$(format_cpu_ranges "$p_core")
com.apple.android.music=$(format_cpu_ranges "$e_core $p_core")

# Lanerc
com.xuzly.hy.lanerc.app{Thread-*}=$(format_cpu_ranges "$p_core")
com.xuzly.hy.lanerc.app{1.ui}=$(format_cpu_ranges "$p_core")
com.xuzly.hy.lanerc.app{mpv/demux}=$(format_cpu_ranges "$p_core")
com.xuzly.hy.lanerc.app{1.raster}=$(format_cpu_ranges "$p_core")
com.xuzly.hy.lanerc.app=$(format_cpu_ranges "$e_core $p_core")

# 起点读书
com.qidian.QDReader{*.QDReader}=$(format_cpu_ranges "$p_core")
com.qidian.QDReader{RenderThread}=$(format_cpu_ranges "$p_core")
com.qidian.QDReader=$(format_cpu_ranges "$e_core $p_core")

# 七猫小说
com.kmxs.reader{*.reader}=$(format_cpu_ranges "$p_core")
com.kmxs.reader{RenderThread}=$(format_cpu_ranges "$p_core")
com.kmxs.reader=$(format_cpu_ranges "$e_core $p_core")

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

#工具型
# 小猿搜题
com.fenbi.android.solar{i.android.solar}=$(format_cpu_ranges "$p_core")
com.fenbi.android.solar{RenderThread}=$(format_cpu_ranges "$p_core")
com.fenbi.android.solar{VizWebView}=$(format_cpu_ranges "$p_core")
com.fenbi.android.solar{Chrome_InProcGp}=$(format_cpu_ranges "$p_core")
com.fenbi.android.solar=$(format_cpu_ranges "$e_core $p_core")

# 豆包
com.larus.nova{RenderThread}=$(format_cpu_ranges "$p_core")
com.larus.nova{com.larus.nova}=$(format_cpu_ranges "$p_core")
com.larus.nova{MediaLoad}=$(format_cpu_ranges "$p_core")
com.larus.nova=$(format_cpu_ranges "$e_core $p_core")

# 3Dmark
com.futuremark.dmandroid.application{Thread-??}=$(format_cpu_ranges "$hp_core")
com.futuremark.dmandroid.application{*binder}=$(format_cpu_ranges "$p_core")
com.futuremark.dmandroid.application=$(format_cpu_ranges "$e_core $p_core")

# chrome
com.android.chrome{RenderThread}=$(format_cpu_ranges "$p_core")
com.android.chrome{.android.chrome}=$(format_cpu_ranges "$p_core")
com.android.chrome=$(format_cpu_ranges "$e_core $p_core")

# via
mark.via{mark.via}=$(format_cpu_ranges "$p_core")
mark.via{RenderThread}=$(format_cpu_ranges "$p_core")
mark.via=$(format_cpu_ranges "$e_core $p_core")

# edge
com.microsoft.emmx{RenderThread}=$(format_cpu_ranges "$p_core")
com.microsoft.emmx{.microsoft.emmx}=$(format_cpu_ranges "$p_core")
com.microsoft.emmx{Thread-*}=$(format_cpu_ranges "$p_core")
com.microsoft.emmx{NetworkService}=$(format_cpu_ranges "$p_core")
com.microsoft.emmx{hwuiTask*}=$(format_cpu_ranges "$p_core")
com.microsoft.emmx=$(format_cpu_ranges "$e_core $p_core")

# DeepSeek
com.deepseek.chat{m.deepseek.chat}=$(format_cpu_ranges "$p_core")
com.deepseek.chat{RenderThread}=$(format_cpu_ranges "$p_core")
com.deepseek.chat=$(format_cpu_ranges "$e_core $p_core")

# 铁路12306
com.MobileTicket{om.MobileTicket}=$(format_cpu_ranges "$p_core")
com.MobileTicket{RenderThread}=$(format_cpu_ranges "$p_core")
com.MobileTicket=$(format_cpu_ranges "$e_core $p_core")

# Breezy Weather
org.breezyweather{RenderThread}=$(format_cpu_ranges "$p_core")
org.breezyweather{g.breezyweather}=$(format_cpu_ranges "$p_core")
org.breezyweather{Binder:*}=$(format_cpu_ranges "$p_core")
org.breezyweather=$(format_cpu_ranges "$e_core $p_core")

#玩机软件
# Noactive
cn.myflv.noactive{.myflv.noactive}=$(format_cpu_ranges "$p_core")
cn.myflv.noactive{RenderThread}=$(format_cpu_ranges "$p_core")
cn.myflv.noactive=$(format_cpu_ranges "$e_core $p_core")

#System
# 将QQ音乐主进程绑定e_core
com.tencent.qqmusic=$(format_cpu_ranges "$e_core")

# 将微信输入法进程绑定e_core
com.tencent.wetype:play=$(format_cpu_ranges "$e_core")

# 将酷狗音乐后台播放的子进程绑定e_core
com.kugou.android.support=$(format_cpu_ranges "$e_core")
com.kugou.android.message=$(format_cpu_ranges "$e_core")

# 将Push消息推送进程绑定e_core
com.tencent.mm:push=$(format_cpu_ranges "$e_core")
com.luna.music:push=$(format_cpu_ranges "$e_core")
com.ss.android.ugc.aweme.mobile:push=$(format_cpu_ranges "$e_core")
com.bilibili.app.in:pushservice=$(format_cpu_ranges "$e_core")
tv.danmaku.bilibilihd:pushservice=$(format_cpu_ranges "$e_core")
tv.danmaku.bili:pushservice=0-1,5
com.tencent.mobileqq:MSF=$(format_cpu_ranges "$e_core")
com.tencent.tim:MSF=$(format_cpu_ranges "$e_core")
com.alibaba.android.rimet:push=$(format_cpu_ranges "$e_core")

# 系统桌面
com.android.launcher{RenderThread}=$(format_cpu_ranges "$p_core")
com.android.launcher{*.launcher}=$(format_cpu_ranges "$p_core")
com.android.launcher{binder*}=$(format_cpu_ranges "$p_core")
com.android.launcher=$(format_cpu_ranges "$e_core $p_core")

# pixel启动器
com.google.android.apps.nexuslauncher{RenderThread}=$(format_cpu_ranges "$p_core")
com.google.android.apps.nexuslauncher{s.nexuslauncher}=$(format_cpu_ranges "$p_core")
com.google.android.apps.nexuslauncher{binder*}=$(format_cpu_ranges "$p_core")
com.google.android.apps.nexuslauncher=$(format_cpu_ranges "$e_core $p_core")

# launcher3
com.android.launcher3{RenderThread}=$(format_cpu_ranges "$p_core")
com.android.launcher3{*.launcher3}=$(format_cpu_ranges "$p_core")
com.android.launcher3{binder*}=$(format_cpu_ranges "$p_core")
com.android.launcher3=$(format_cpu_ranges "$e_core $p_core")

# oneuilauncher
com.sec.android.app.launcher{RenderThread}=$(format_cpu_ranges "$p_core")
com.sec.android.app.launcher{id.app.launcher}=$(format_cpu_ranges "$p_core")
com.sec.android.app.launcher{binder*}=$(format_cpu_ranges "$p_core")
com.sec.android.app.launcher=$(format_cpu_ranges "$e_core $p_core")
