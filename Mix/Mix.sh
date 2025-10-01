"********************************************"
common_rules="
#通讯
# 微信
com.tencent.mm{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.tencent.mm{com.tencent.mm}=$(format_cpu_ranges "$p_core")
com.tencent.mm{default_matrix_}=$(format_cpu_ranges "$p_core")
com.tencent.mm{binder:*}=$(format_cpu_ranges "$p_core")
com.tencent.mm=$(format_cpu_ranges "$p_core")

# QQ
com.tencent.mobileqq{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.tencent.mobileqq{MediaCodec_loop}=$(format_cpu_ranges "$e_core $p_core")
com.tencent.mobileqq{encent.mobileqq}=$(format_cpu_ranges "$p_core")
com.tencent.mobileqq=$(format_cpu_ranges "$p_core")

# TIM
com.tencent.tim{com.tencent.tim}=$(format_cpu_ranges "$p_core")
com.tencent.tim{RenderThread}=$(format_cpu_ranges "$p_core")
com.tencent.tim{HeapTaskDaemon}=$(format_cpu_ranges "$p_core")
com.tencent.tim=$(format_cpu_ranges "$p_core")

# Nekogram
tw.nekomimi.nekogram{RehderThread}=$(format_cpu_ranges "$e_core $p_core")
tw.nekomimi.nekogram{files_database_}=$(format_cpu_ranges "$p_core")
tw.nekomimi.nekogram{searchQueue}$(format_cpu_ranges "$p_core")
tw.nekomimi.nekogram{komimi.nekogram}=$(format_cpu_ranges "$p_core")
tw.nekomimi.nekogram=$(format_cpu_ranges "$p_core")

# telegram
org.telegram.group{Thread-*}=$(format_cpu_ranges "$e_core $p_core")
org.telegram.group{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
org.telegram.group{.telegram.group}=$(format_cpu_ranges "$p_core")
org.telegram.group=$(format_cpu_ranges "$p_core")

# Nagram X
nu.gpu.nagram{Thread-*}=$(format_cpu_ranges "$e_core $p_core")
nu.gpu.nagram{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
nu.gpu.nagram{nu.gpu.nagram}=$(format_cpu_ranges "$p_core")
nu.gpu.nagram=$(format_cpu_ranges "$p_core")

# Ayugram
com.radolyn.ayugram{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.radolyn.ayugram{radolyn.ayugram}=$(format_cpu_ranges "$p_core")
com.radolyn.ayugram{SpoilerEffectBi}=$(format_cpu_ranges "$p_core")
com.radolyn.ayugram{Thread-*}=$(format_cpu_ranges "$e_core $p_core")
com.radolyn.ayugram=$(format_cpu_ranges "$p_core")

# 钉钉
com.alibaba.android.rimet{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.alibaba.android.rimet{a.android.rimet}=$(format_cpu_ranges "$p_core")
com.alibaba.android.rimet{Doraemon-Proces}=$(format_cpu_ranges "$p_core")
com.alibaba.android.rimet=$(format_cpu_ranges "$p_core")

#购物
# 淘宝
com.taobao.taobao{WeexJSBridgeTh}=$(format_cpu_ranges "$e_core $p_core")
com.taobao.taobao{HeapTaskDaemon}=$(format_cpu_ranges "$p_core")
com.taobao.taobao{m.taobao.taobao}=$(format_cpu_ranges "$p_core")
com.taobao.taobao{8RYPVI8EZKhJUU}=$(format_cpu_ranges "$p_core")
com.taobao.taobao=$(format_cpu_ranges "$p_core")

# 京东
com.jingdong.app.mall{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.jingdong.app.mall{pool-15-thread-}=$(format_cpu_ranges "$e_core $p_core")
com.jingdong.app.mall{RunnerWrapper_8}=$(format_cpu_ranges "$p_core")
com.jingdong.app.mall{ngdong.app.mall}=$(format_cpu_ranges "$p_core")
com.jingdong.app.mall{JDFileDownloade}=$(format_cpu_ranges "$p_core")
com.jingdong.app.mall=$(format_cpu_ranges "$p_core")

# 拼多多
com.xunmeng.pinduoduo{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.xunmeng.pinduoduo{Chat#Single-Syn}=$(format_cpu_ranges "$p_core")
com.xunmeng.pinduoduo{Startup#RTDispa}=$(format_cpu_ranges "$p_core")
com.xunmeng.pinduoduo{nmeng.pinduoduo}=$(format_cpu_ranges "$p_core")
com.xunmeng.pinduoduo=$(format_cpu_ranges "$p_core")

# 闲鱼
com.taobao.idlefish{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.taobao.idlefish{1.ui}=$(format_cpu_ranges "$p_core")
com.taobao.idlefish{taobao.idlefish}=$(format_cpu_ranges "$p_core")
com.taobao.idlefish{1.raster}=$(format_cpu_ranges "$p_core")
com.taobao.idlefish=$(format_cpu_ranges "$p_core")

# 美团
com.sankuai.meituan{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.sankuai.meituan{sankuai.meituan}=$(format_cpu_ranges "$p_core")
com.sankuai.meituan{TTE-keyAgreemen}=$(format_cpu_ranges "$p_core")
com.sankuai.meituan=$(format_cpu_ranges "$p_core")

# 支付宝
com.eg.android.AlipayGphone{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.eg.android.AlipayGphone{crv-worker-thre}=$(format_cpu_ranges "$p_core")
com.eg.android.AlipayGphone{id.AlipayGphone}=$(format_cpu_ranges "$p_core")
com.eg.android.AlipayGphone=$(format_cpu_ranges "$p_core")

# 美团外卖
com.sankuai.meituan.takeoutnew{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.sankuai.meituan.takeoutnew{tuan.takeoutnew}=$(format_cpu_ranges "$p_core")
com.sankuai.meituan.takeoutnew{J*}=$(format_cpu_ranges "$p_core")
com.sankuai.meituan.takeoutnew=$(format_cpu_ranges "$p_core")

# 饿了么
me.ele{me.ele}=$(format_cpu_ranges "$hp_core")
me.ele{dp2ndk}=$(format_cpu_ranges "$e_core $p_core")
me.ele{Xxdn-Worker}=$(format_cpu_ranges "$e_core $p_core")
me.ele{1.raster}=$(format_cpu_ranges "$e_core $p_core")
me.ele{2.raster}=$(format_cpu_ranges "$e_core $p_core")
me.ele=$(format_cpu_ranges "$p_core")

#娱乐社媒
# 哔哩哔哩
tv.danmaku.bili{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
tv.danmaku.bili{Thread-*}=$(format_cpu_ranges "$e_core $p_core")
tv.danmaku.bili{IJK_External_Re}=$(format_cpu_ranges "$e_core $p_core")
tv.danmaku.bili{CRON.Main}=$(format_cpu_ranges "$p_core")
tv.danmaku.bili{tv.danmaku.bili}=$(format_cpu_ranges "$p_core")
tv.danmaku.bili{ijk_ext_render}=$(format_cpu_ranges "$p_core")
tv.danmaku.bili{MediaCodec_loop}=$(format_cpu_ranges "$p_core")
tv.danmaku.bili=$(format_cpu_ranges "$p_core")

# 哔哩哔哩Play
com.bilibili.app.in{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.bilibili.app.in{*.app.in}=$(format_cpu_ranges "$e_core $p_core")
tv.danmaku.bili{Thread-*}=$(format_cpu_ranges "$e_core $p_core")
com.bilibili.app.in=$(format_cpu_ranges "$p_core")

# piliplus
com.example.piliplus{Thread-*}=$(format_cpu_ranges "$e_core $p_core")
com.example.piliplus{1.raster}=$(format_cpu_ranges "$p_core")
com.example.piliplus{1.ui}=$(format_cpu_ranges "$p_core")
com.example.piliplus=$(format_cpu_ranges "$p_core")

# 快手
com.smile.gifmaker{RenderThread}=$(format_cpu_ranges "$p_core")
com.smile.gifmaker{smile.gifmaker}=$(format_cpu_ranges "$p_core")
com.smile.gifmaker{MediaCodec_*}=$(format_cpu_ranges "$p_core")
com.smile.gifmaker=$(format_cpu_ranges "$p_core")

# 爱奇艺
com.qiyi.video{PLAYER_INFLATE_}=$(format_cpu_ranges "$p_core")
com.qiyi.video{RenderThread}=$(format_cpu_ranges "$p_core")
com.qiyi.video{DanmakuGLThread}=$(format_cpu_ranges "$p_core")
com.qiyi.video{com.qiyi.video}=$(format_cpu_ranges "$p_core")
com.qiyi.video{PumaPlyrVEgn}=$(format_cpu_ranges "$p_core")
com.qiyi.video=$(format_cpu_ranges "$p_core")

# 抖音 
com.ss.android.ugc.aweme{*Thread}=$(format_cpu_ranges "$p_core")
com.ss.android.ugc.aweme{VDecod2-*}=$(format_cpu_ranges "$p_core")
com.ss.android.ugc.aweme{HeapTaskDaemon}=$(format_cpu_ranges "$p_core")
com.ss.android.ugc.aweme{danmaku-driver}=$(format_cpu_ranges "$p_core")
com.ss.android.ugc.aweme{droid.ugc.aweme}=$(format_cpu_ranges "$p_core")
com.ss.android.ugc.aweme{#pty-wqp-*}=$(format_cpu_ranges "$p_core")
com.ss.android.ugc.aweme=$(format_cpu_ranges "$p_core")

# 酷安
com.coolapk.market{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.coolapk.market{Thread-*}=$(format_cpu_ranges "$e_core $p_core")
com.coolapk.market{binder:*}=$(format_cpu_ranges "$p_core")
com.coolapk.market{.coolapk.market}=$(format_cpu_ranges "$p_core")
com.coolapk.market=$(format_cpu_ranges "$p_core")

# 微博
com.sina.weibo{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.sina.weibo{Thread-*}=$(format_cpu_ranges "$e_core $p_core")
com.sina.weibo{com.sina.weibo}=$(format_cpu_ranges "$p_core")
com.sina.weibo=$(format_cpu_ranges "$p_core")

# 贴吧
com.baidu.tieba{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.baidu.tieba{com.baidu.tieba}=$(format_cpu_ranges "$p_core")
com.baidu.tieba=$(format_cpu_ranges "$p_core")

# 知乎
com.zhihu.android{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.zhihu.android{m.zhihu.android}=$(format_cpu_ranges "$p_core")
com.zhihu.android=$(format_cpu_ranges "$p_core")

# X
com.twitter.android{twitter.android}=$(format_cpu_ranges "$p_core")
com.twitter.android{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.twitter.android{MediaCodec loop}=$(format_cpu_ranges "$e_core $p_core")
com.twitter.android=$(format_cpu_ranges "$p_core")

# YouTube
com.google.android.youtube{android.youtube}=$(format_cpu_ranges "$p_core")
com.google.android.youtube{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.google.android.youtube{ExoPlayer:Playb}=$(format_cpu_ranges "$e_core $p_core")
com.google.android.youtube{MediaCodec loop}=$(format_cpu_ranges "$e_core $p_core")
com.google.android.youtube=$(format_cpu_ranges "$p_core")

# Facebook
com.facebook.katana{facebook.katana}=$(format_cpu_ranges "$p_core")
com.facebook.katana{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.facebook.katana{ComponentLavout}=$(format_cpu_ranges "$e_core $p_core")
com.facebook.katana=$(format_cpu_ranges "$p_core")

# Discord
com.discord{com.discord}=$(format_cpu_ranges "$p_core")
com.discord{pool-10-thread-*}=$(format_cpu_ranges "$e_core $p_core")
com.discord{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.discord{mqt js}=$(format_cpu_ranges "$p_core")
com.discord=$(format_cpu_ranges "$p_core")

# Lanerc
com.xuzly.hy.lanerc.app{Thread-*}=$(format_cpu_ranges "$e_core $p_core")
com.xuzly.hy.lanerc.app{1.ui}=$(format_cpu_ranges "$p_core")
com.xuzly.hy.lanerc.app{mpv/demux}=$(format_cpu_ranges "$p_core")
com.xuzly.hy.lanerc.app{1.raster}=$(format_cpu_ranges "$p_core")
com.xuzly.hy.lanerc.app=$(format_cpu_ranges "$p_core")

# 网易云音乐
com.netease.cloudmusic{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.netease.cloudmusic{ease.cloudmusic}=$(format_cpu_ranges "$p_core")
com.netease.cloudmusic{LooperTracer}=$(format_cpu_ranges "$p_core")
com.netease.cloudmusic=$(format_cpu_ranges "$p_core")

# 酷狗概念版
com.kugou.android.lite{ou.android.lite}=$(format_cpu_ranges "$p_core")
com.kugou.android.lite{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.kugou.android.lite=$(format_cpu_ranges "$p_core")

# 汽水音乐
com.luna.music{*.music}=$(format_cpu_ranges "$p_core")
com.luna.music{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.luna.music=$(format_cpu_ranges "$p_core")

# Salt Player
com.salt.music{com.salt.music}=$(format_cpu_ranges "$p_core")
com.salt.music{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.salt.music=$(format_cpu_ranges "$p_core")

# 喜马拉雅
com.ximalaya.ting.android{ya.ting.android}=$(format_cpu_ranges "$p_core")
com.ximalaya.ting.android{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.ximalaya.ting.android=$(format_cpu_ranges "$p_core")

# Apple Music
com.apple.android.music{*.music}=$(format_cpu_ranges "$p_core")
com.apple.android.music{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.apple.android.music=$(format_cpu_ranges "$p_core")

# Lanerc
com.xuzly.hy.lanerc.app{Thread-*}=$(format_cpu_ranges "$e_core $p_core")
com.xuzly.hy.lanerc.app{1.ui}=$(format_cpu_ranges "$p_core")
com.xuzly.hy.lanerc.app{mpv/demux}=$(format_cpu_ranges "$p_core")
com.xuzly.hy.lanerc.app{1.raster}=$(format_cpu_ranges "$p_core")
com.xuzly.hy.lanerc.app=$(format_cpu_ranges "$p_core")

# 起点读书
com.qidian.QDReader{*.QDReader}=$(format_cpu_ranges "$p_core")
com.qidian.QDReader{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.qidian.QDReader=$(format_cpu_ranges "$p_core")

# 七猫小说
com.kmxs.reader{*.reader}=$(format_cpu_ranges "$p_core")
com.kmxs.reader{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.kmxs.reader=$(format_cpu_ranges "$p_core")

#地图
# 高德地图  
com.autonavi.minimap{AJXBizCheck}=$(format_cpu_ranges "$p_core")  
com.autonavi.minimap{JavaScriptThrea}=$(format_cpu_ranges "$p_core")
com.autonavi.minimap{Map-Logical-0}=$(format_cpu_ranges "$p_core") 
com.autonavi.minimap{utonavi.minimap}=$(format_cpu_ranges "$p_core")
com.autonavi.minimap=$(format_cpu_ranges "$p_core")  

# 百度地图  
com.baidu.BaiduMap{31.1_0223536945}=$(format_cpu_ranges "$p_core") 
com.baidu.BaiduMap{.31.1_062565145}=$(format_cpu_ranges "$p_core") 
com.baidu.BaiduMap{.baidu.BaiduMap}=$(format_cpu_ranges "$p_core") 
com.baidu.BaiduMap{*Thread}=$(format_cpu_ranges "$p_core") 
com.baidu.BaiduMap=$(format_cpu_ranges "$p_core")

#工具型
# 3Dmark
com.futuremark.dmandroid.application{Thread-??}=$(format_cpu_ranges "$hp_core")
com.futuremark.dmandroid.application{*binder}=$(format_cpu_ranges "$e_core $p_core")
com.futuremark.dmandroid.application=$(format_cpu_ranges "$p_core")

# chrome
com.android.chrome{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.android.chrome{.android.chrome}=$(format_cpu_ranges "$p_core")
com.android.chrome=$(format_cpu_ranges "$p_core")

# via
mark.via{mark.via}=$(format_cpu_ranges "$p_core")
mark.via{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
mark.via=$(format_cpu_ranges "$p_core")

# DeepSeek
com.deepseek.chat{m.deepseek.chat}=$(format_cpu_ranges "$p_core")
com.deepseek.chat{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.deepseek.chat=$(format_cpu_ranges "$p_core")

# 铁路12306
com.MobileTicket{om.MobileTicket}=$(format_cpu_ranges "$p_core")
com.MobileTicket{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.MobileTicket=$(format_cpu_ranges "$p_core")

#玩机软件
# Noactive
cn.myflv.noactive{.myflv.noactive}=$(format_cpu_ranges "$p_core")
cn.myflv.noactive{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
cn.myflv.noactive=$(format_cpu_ranges "$p_core")

#工具性
# 将 'Android图形显示组件'渲染引擎线程绑定到大核
surfaceflinger{RenderEngine}=$(format_cpu_ranges "$hp_core")

# 允许 'Android图形显示组件' 使用所有CPU核心$all_core
surfaceflinger=$all_core

# 将 '系统界面' 渲染引擎线程与主线程绑定到中大核
com.android.systemui{RenderThread}=$(format_cpu_ranges "$hp_core")
com.android.systemui{ndroid.systemui}=$(format_cpu_ranges "$p_core $hp_core")

# 将QQ音乐主进程绑定0,1,5
com.tencent.qqmusic=$(format_cpu_ranges "$e_core $p_core")

# 将微信输入法进程绑定0,1,5
com.tencent.wetype:play=$(format_cpu_ranges "$e_core $p_core")

# 将酷狗音乐后台播放的子进程绑定0,1,5
com.kugou.android.support=$(format_cpu_ranges "$e_core $p_core")
com.kugou.android.message=$(format_cpu_ranges "$e_core $p_core")

# 将微信Push消息推送进程绑定0,1,5
com.tencent.mm:push=$(format_cpu_ranges "$e_core $p_core")

# 系统桌面
com.android.launcher{RenderThread}=$(format_cpu_ranges "$p_core")
com.android.launcher{binder*}=$(format_cpu_ranges "$p_core")
com.android.launcher{ndroid.launcher}=$(format_cpu_ranges "$p_core")
com.android.launcher=$(format_cpu_ranges "$e_core $p_core")

# pixel启动器
com.google.android.apps.nexuslauncher{RenderThread}=$(format_cpu_ranges "$p_core")
com.google.android.apps.nexuslauncher{s.nexuslauncher}=$(format_cpu_ranges "$p_core")
com.google.android.apps.nexuslauncher{binder*}=$(format_cpu_ranges "$p_core")
com.google.android.apps.nexuslauncher=$(format_cpu_ranges "$e_core $p_core")

# launcher3
com.android.launcher3{RenderThread}=$(format_cpu_ranges "$p_core")
com.android.launcher3{droid.launcher3}=$(format_cpu_ranges "$p_core")
com.android.launcher3{binder*}=$(format_cpu_ranges "$p_core")
com.android.launcher3=$(format_cpu_ranges "$e_core $p_core")

# 3Dmark
com.futuremark.dmandroid.application{Thread-??}=$(format_cpu_ranges "$hp_core")
com.futuremark.dmandroid.application{*binder}=$(format_cpu_ranges "$p_core")
com.futuremark.dmandroid.application=$(format_cpu_ranges "$e_core $p_core")

# chrome
com.android.chrome{RenderThread}=$(format_cpu_ranges "$p_core")
com.android.chrome{.android.chrome}=$(format_cpu_ranges "$p_core")
com.android.chrome=$(format_cpu_ranges "$e_core $p_core")
"
game_rules="
#Game
# 王者荣耀
com.tencent.tmgp.sgame{UnityMain}=$(format_cpu_ranges "$hp_core")
com.tencent.tmgp.sgame{UnityGfxDeviceW}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.sgame{Thread*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.sgame{Job.worker*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.sgame=$(format_cpu_ranges "$e_core $p_core")

# 和平精英
com.tencent.tmgp.pubgmhd{Thread-[0-9]}=$(format_cpu_ranges "$hp_core")
com.tencent.tmgp.pubgmhd{Thread-1[0-5]}=$(format_cpu_ranges "$hp_core")
com.tencent.tmgp.pubgmhd{RHIThread}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.pubgmhd{RenderThread*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.pubgmhd=$(format_cpu_ranges "$e_core $p_core")

# PUBGM GLO
com.tencent.ig{RenderThread*}=$(format_cpu_ranges "$hp_core")
com.tencent.ig{UEGameThread}=$(format_cpu_ranges "$p_core")
com.tencent.ig{NativeThread}=$(format_cpu_ranges "$p_core")
com.tencent.ig{TaskGraphNP*}=$(format_cpu_ranges "$p_core")
com.tencent.ig=$(format_cpu_ranges "$e_core $p_core")

# 使命召唤手游
com.tencent.tmgp.cod{UnityMain*}=$(format_cpu_ranges "$hp_core")
com.tencent.tmgp.cod{UnityGfx*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.cod{Thread-*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.cod{Job.worker*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.cod{Audio*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.cod=$(format_cpu_ranges "$e_core $p_core")

# 明日方舟
com.hypergryph.arknights{UnityMain*}=$(format_cpu_ranges "$hp_core")
com.hypergryph.arknights{UnityGfx*}=$(format_cpu_ranges "$p_core")
com.hypergryph.arknights{Thread-*}=$(format_cpu_ranges "$p_core")
com.hypergryph.arknights{Job.worker*}=$(format_cpu_ranges "$p_core")
com.hypergryph.arknights{Audio*}=$(format_cpu_ranges "$e_core $p_core")
com.hypergryph.arknights=$(format_cpu_ranges "$p_core")

# 原神
com.miHoYo.Yuanshen{UnityMain*}=$(format_cpu_ranges "$hp_core")
com.miHoYo.Yuanshen{UnityGfx*}=$(format_cpu_ranges "$p_core")
com.miHoYo.Yuanshen{Thread-*}=$(format_cpu_ranges "$p_core")
com.miHoYo.Yuanshen{Job.worker*}=$(format_cpu_ranges "$p_core")
com.miHoYo.Yuanshen=$(format_cpu_ranges "$e_core $p_core")

# 崩坏:星穹铁道
com.miHoYo.hkrpg{UnityMain*}=$(format_cpu_ranges "$hp_core")
com.miHoYo.hkrpg{UnityGfx*}=$(format_cpu_ranges "$p_core")
com.miHoYo.hkrpg{Thread-*}=$(format_cpu_ranges "$p_core")
com.miHoYo.hkrpg{Job.worker*}=$(format_cpu_ranges "$p_core")
com.miHoYo.hkrpg=$(format_cpu_ranges "$e_core $p_core")

# 绝区零
com.miHoYo.Nap{UnityMain}=$(format_cpu_ranges "$hp_core")
com.miHoYo.Nap{UnityGfxDeviceW}=$(format_cpu_ranges "$p_core")
com.miHoYo.Nap{Job.Worker*}=$(format_cpu_ranges "$p_core")
com.miHoYo.Nap{NativeThread}=$(format_cpu_ranges "$p_core")
com.miHoYo.Nap{Thread-*}=$(format_cpu_ranges "$p_core")
com.miHoYo.Nap=$(format_cpu_ranges "$e_core $p_core")

# 鸣潮
com.kurogame.mingchao{GameThread}=$(format_cpu_ranges "$hp_core")
com.kurogame.mingchao{RHIThread}=$(format_cpu_ranges "$p_core")
com.kurogame.mingchao{RenderThread 1}=$(format_cpu_ranges "$p_core")
com.kurogame.mingchao{NativeThread}=$(format_cpu_ranges "$p_core")
com.kurogame.mingchao=$(format_cpu_ranges "$e_core $p_core")

# CFM
com.tencent.tmgp.cf{UnityMain}=$(format_cpu_ranges "$hp_core")
com.tencent.tmgp.cf{UnityGfxDeviceW}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.cf{Thread-*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.cf=$(format_cpu_ranges "$e_core $p_core")

# 火影忍者
com.tencent.KiHan{UnityMain}=$(format_cpu_ranges "$hp_core")
com.tencent.KiHan{UnityGfxDeviceW}=$(format_cpu_ranges "$p_core")
com.tencent.KiHan{Job.Worker*}=$(format_cpu_ranges "$p_core")
com.tencent.KiHan=$(format_cpu_ranges "$e_core $p_core")

# 三角洲行动
com.tencent.tmgp.dfm{GameThread}=$(format_cpu_ranges "$hp_core")
com.tencent.tmgp.dfm{RenderThread}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.dfm{Thread-*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.dfm{TaskGraphNP*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.dfm{NativeThread}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.dfm=$(format_cpu_ranges "$e_core $p_core")

# 妮姬：新的希望
com.tencent.nikke{UnityMain}=$(format_cpu_ranges "$hp_core")
com.tencent.nikke{Thread-*}=$(format_cpu_ranges "$p_core")
com.tencent.nikke{UnityChoreograp}=$(format_cpu_ranges "$p_core")
com.tencent.nikke=$(format_cpu_ranges "$e_core $p_core")

# NIKKE
com.gamamobi.nikke{UnityMain}=$(format_cpu_ranges "$hp_core")
com.gamamobi.nikke{Thread-*}=$(format_cpu_ranges "$p_core")
com.gamamobi.nikke{UnityChoreograp}=$(format_cpu_ranges "$p_core")
com.gamamobi.nikke{FMOD*}=$(format_cpu_ranges "$p_core")
com.gamamobi.nikke=$(format_cpu_ranges "$e_core $p_core")

# 荒野乱斗
com.tencent.tmgp.supercell.brawlstars{Mainloop}=$(format_cpu_ranges "$hp_core")
com.tencent.tmgp.supercell.brawlstars{Thread-*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.supercell.brawlstars=$(format_cpu_ranges "$e_core $p_core")

# 无畏契约
com.tencent.tmgp.codev{GameThread}=$(format_cpu_ranges "$hp_core")
com.tencent.tmgp.codev{RenderThread}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.codev{NativeThread}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.codev=$(format_cpu_ranges "$e_core $p_core")

# BlueArchive(GLO)
com.nexon.bluearchive{xon.bluearchive}=$(format_cpu_ranges "$hp_core")
com.nexon.bluearchive{UnityMain}=$(format_cpu_ranges "$p_core")
com.nexon.bluearchive{UnityGfxDeviceW10}=$(format_cpu_ranges "$p_core")
com.nexon.bluearchive{UnityChoreograp}=$(format_cpu_ranges "$p_core")
com.nexon.bluearchive=$(format_cpu_ranges "$e_core $p_core")

# 少女前线2:追放
com.Sunborn.SnqxExilium{UnityMain}=$(format_cpu_ranges "$hp_core")
com.Sunborn.SnqxExilium{UnityGfx*}=$(format_cpu_ranges "$p_core")
com.Sunborn.SnqxExilium{Job.[Ww]orker*}=$(format_cpu_ranges "$p_core")
com.Sunborn.SnqxExilium{Thread-*}=$(format_cpu_ranges "$p_core")
com.Sunborn.SnqxExilium=$(format_cpu_ranges "$e_core $p_core")

# DNF
com.tencent.tmgp.dnf{UnityMain}=$(format_cpu_ranges "$hp_core")
com.tencent.tmgp.dnf{Thread-[0-9]*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.dnf{UnityChoreograp}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.dnf{UnityGfxDeviceW}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.dnf=$(format_cpu_ranges "$e_core $p_core")

# 英雄联盟
com.tencent.lolm{UnityMain}=$(format_cpu_ranges "$hp_core")
com.tencent.lolm{LogicThread}=$(format_cpu_ranges "$p_core")
com.tencent.lolm{Thread-*}=$(format_cpu_ranges "$p_core")
com.tencent.lolm{NativeThread}=$(format_cpu_ranges "$p_core")
com.tencent.lolm=$(format_cpu_ranges "$e_core $p_core")

# 金铲铲之战
com.tencent.jkchess{UnityMain}=$(format_cpu_ranges "$hp_core")
com.tencent.jkchess{Thread-*}=$(format_cpu_ranges "$p_core")
com.tencent.jkchess{LogicThread}=$(format_cpu_ranges "$p_core")
com.tencent.jkchess=$(format_cpu_ranges "$e_core $p_core")

# 皇室战争
com.tencent.tmgp.supercell.clashroyale{Mainloop}=$(format_cpu_ranges "$hp_core")
com.tencent.tmgp.supercell.clashroyale{Thread-*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.supercell.clashroyale{FMOD mixer thre}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.supercell.clashroyale=$(format_cpu_ranges "$e_core $p_core")

# 荒野乱斗
com.tencent.tmgp.supercell.brawlstars{Mainloop}=$(format_cpu_ranges "$hp_core")
com.tencent.tmgp.supercell.brawlstars{FMOD mixer thre}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.supercell.brawlstars{Thread-*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.supercell.brawlstars=$(format_cpu_ranges "$e_core $p_core")

# 尘白禁区
com.dragonli.projectsnow.lhm{RHIThread}=$(format_cpu_ranges "$hp_core")
com.dragonli.projectsnow.lhm{RenderThread*}=$(format_cpu_ranges "$p_core")
com.dragonli.projectsnow.lhm{GameThread}=$(format_cpu_ranges "$p_core")
com.dragonli.projectsnow.lhm=$(format_cpu_ranges "$e_core $p_core")

# 极限竞速
com.netease.race{RHIThread}=$(format_cpu_ranges "$hp_core")
com.netease.race{GameThread}=$(format_cpu_ranges "$e_core $p_core")
com.netease.race{RenderThread}=$(format_cpu_ranges "$e_core $p_core")
com.netease.race{Thread-*}=$(format_cpu_ranges "$p_core")
com.netease.race=$(format_cpu_ranges "$e_core $p_core")

# qq飞车
com.tencent.tmgp.speedmobile{UnityMain}=$(format_cpu_ranges "$hp_core")
com.tencent.tmgp.speedmobile{Thread-*}=$(format_cpu_ranges "$e_core $p_core")
com.tencent.tmgp.speedmobile{UnityGfxRenderS}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.speedmobile{Job.Worker*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.speedmobile=$(format_cpu_ranges "$e_core $p_core")

# 雀魂
com.soulgamechst.majsoul{Thread-??}=$(format_cpu_ranges "$p_core")
#垃圾线程
com.soulgamechst.majsoul{UnityMain}=$(format_cpu_ranges "$e_core $p_core")
com.soulgamechst.majsoul{Job.Worker*}=2$(format_cpu_ranges "$p_core")
com.soulgamechst.majsoul=$(format_cpu_ranges "$e_core $p_core")
"