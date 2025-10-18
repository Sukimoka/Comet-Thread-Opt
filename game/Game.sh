"********************************************"
game_rules="
#Game
# 王者荣耀
com.tencent.tmgp.sgame{UnityMain}=$(format_cpu_ranges "$hp_core")
com.tencent.tmgp.sgame{UnityGfxDeviceW}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.sgame{Thread*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.sgame{Job.worker*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.sgame{CoreThread}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.sgame=$(format_cpu_ranges "$e_core $p_core")

# 和平精英
com.tencent.tmgp.pubgmhd{Thread-*}=$(format_cpu_ranges "$hp_core")
com.tencent.tmgp.pubgmhd{RHIThread}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.pubgmhd{TaskGraphNP*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.pubgmhd{RenderThread*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.pubgmhd=$(format_cpu_ranges "$e_core $p_core")

# PUBGM GLO
com.tencent.ig{RenderThread*}=$(format_cpu_ranges "$hp_core")
com.tencent.ig{UEGameThread}=2-$(format_cpu_ranges "$hp_core")
com.tencent.ig{TaskGraphNP*}=2-$(format_cpu_ranges "$hp_core")
com.tencent.ig{MainThread-UE4}=$(format_cpu_ranges "$p_core"),$(format_cpu_ranges "$hp_core")
com.tencent.ig=$(format_cpu_ranges "$e_core $p_core")

# 使命召唤手游
com.tencent.tmgp.cod{UnityMain*}=$(format_cpu_ranges "$hp_core")
com.tencent.tmgp.cod{UnityGfx*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.cod{Thread-*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.cod{Job.worker*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.cod{Audio*}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.cod=$(format_cpu_ranges "$e_core $p_core")

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
com.miHoYo.GenshinImpact{UnityMain*}=$(format_cpu_ranges "$hp_core")
com.miHoYo.GenshinImpact{UnityGfx*}=$(format_cpu_ranges "$p_core")
com.miHoYo.GenshinImpact{Thread-*}=$(format_cpu_ranges "$p_core")
com.miHoYo.GenshinImpact{Job.worker*}=$(format_cpu_ranges "$p_core")
com.miHoYo.GenshinImpact=$(format_cpu_ranges "$e_core $p_core")
com.miHoYo.ys.bilibili{UnityMain*}=$(format_cpu_ranges "$hp_core")
com.miHoYo.ys.bilibili{UnityGfx*}=$(format_cpu_ranges "$p_core")
com.miHoYo.ys.bilibili{Thread-*}=$(format_cpu_ranges "$p_core")
com.miHoYo.ys.bilibili{Job.worker*}=$(format_cpu_ranges "$p_core")
com.miHoYo.ys.bilibili=$(format_cpu_ranges "$e_core $p_core")
com.miHoYo.ys.mi{UnityMain*}=$(format_cpu_ranges "$hp_core")
com.miHoYo.ys.mi{UnityGfx*}=$(format_cpu_ranges "$p_core")
com.miHoYo.ys.mi{Thread-*}=$(format_cpu_ranges "$p_core")
com.miHoYo.ys.mi{Job.worker*}=$(format_cpu_ranges "$p_core")
com.miHoYo.ys.mi=$(format_cpu_ranges "$e_core $p_core")

# 崩坏:星穹铁道
com.miHoYo.hkrpg{UnityMain*}=$(format_cpu_ranges "$hp_core")
com.miHoYo.hkrpg{UnityGfx*}=$(format_cpu_ranges "$p_core")
com.miHoYo.hkrpg{Thread-*}=$(format_cpu_ranges "$p_core")
com.miHoYo.hkrpg{Job.worker*}=$(format_cpu_ranges "$p_core")
com.miHoYo.hkrpg=$(format_cpu_ranges "$e_core $p_core")
com.miHoYo.hkrpg.bilibili{UnityMain*}=$(format_cpu_ranges "$hp_core")
com.miHoYo.hkrpg.bilibili{UnityGfx*}=$(format_cpu_ranges "$p_core")
com.miHoYo.hkrpg.bilibili{Thread-*}=$(format_cpu_ranges "$p_core")
com.miHoYo.hkrpg.bilibili{Job.worker*}=$(format_cpu_ranges "$p_core")
com.miHoYo.hkrpg.bilibili=$(format_cpu_ranges "$e_core $p_core")
com.HoYoverse.hkrpgoversea{UnityMain*}=$(format_cpu_ranges "$hp_core")
com.HoYoverse.hkrpgoversea{UnityGfx*}=$(format_cpu_ranges "$p_core")
com.HoYoverse.hkrpgoversea{Thread-*}=$(format_cpu_ranges "$p_core")
com.HoYoverse.hkrpgoversea{Job.worker*}=$(format_cpu_ranges "$p_core")
com.HoYoverse.hkrpgoversea=$(format_cpu_ranges "$e_core $p_core")

# 绝区零
com.miHoYo.Nap{UnityMain}=$(format_cpu_ranges "$hp_core")
com.miHoYo.Nap{UnityGfxDeviceW}=$(format_cpu_ranges "$p_core")
com.miHoYo.Nap{Job.Worker*}=$(format_cpu_ranges "$p_core")
com.miHoYo.Nap{NativeThread}=$(format_cpu_ranges "$p_core")
com.miHoYo.Nap{Thread-*}=$(format_cpu_ranges "$p_core")
com.miHoYo.Nap=$(format_cpu_ranges "$e_core $p_core")
com.HoYoverse.Nap{UnityMain}=$(format_cpu_ranges "$hp_core")
com.HoYoverse.Nap{UnityGfxDeviceW}=$(format_cpu_ranges "$p_core")
com.HoYoverse.Nap{Job.Worker*}=$(format_cpu_ranges "$p_core")
com.HoYoverse.Nap{NativeThread}=$(format_cpu_ranges "$p_core")
com.HoYoverse.Nap{Thread-*}=$(format_cpu_ranges "$p_core")
com.HoYoverse.Nap=$(format_cpu_ranges "$e_core $p_core")
com.mihoyo.nap.bilibili{UnityMain}=$(format_cpu_ranges "$hp_core")
com.mihoyo.nap.bilibili{UnityGfxDeviceW}=$(format_cpu_ranges "$p_core")
com.mihoyo.nap.bilibili{Job.Worker*}=$(format_cpu_ranges "$p_core")
com.mihoyo.nap.bilibili{NativeThread}=$(format_cpu_ranges "$p_core")
com.mihoyo.nap.bilibili{Thread-*}=$(format_cpu_ranges "$p_core")
com.mihoyo.nap.bilibili=$(format_cpu_ranges "$e_core $p_core")

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
com.tencent.tmgp.dnf{Thread-[0-9]*}=$(format_cpu_ranges "$e_core $p_core")
com.tencent.tmgp.dnf{UnityChoreograp}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.dnf{UnityGfxDeviceW}=$(format_cpu_ranges "$p_core")
com.tencent.tmgp.dnf=$(format_cpu_ranges "$e_core $p_core")

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
com.soulgamechst.majsoul{Thread-??}=$(format_cpu_ranges "$p_core")      #垃圾线程
com.soulgamechst.majsoul{UnityMain}=$(format_cpu_ranges "$e_core $p_core")
com.soulgamechst.majsoul{Job.Worker*}=$(format_cpu_ranges "$p_core")
com.soulgamechst.majsoul=$(format_cpu_ranges "$e_core $p_core")

# 崩坏3(官服)
com.miHoYo.enterprise.NGHSoD{UnityMain}=$(format_cpu_ranges "$hp_core")
com.miHoYo.enterprise.NGHSoD{UnityGfxDeviceW}=$(format_cpu_ranges "$p_core")
com.miHoYo.enterprise.NGHSoD{NativeThread}=$(format_cpu_ranges "$p_core")
com.miHoYo.enterprise.NGHSoD=$(format_cpu_ranges "$e_core $p_core")

# 多乐够级(HW)
com.k7k7.goujihd.huawei{GLThread*}=$(format_cpu_ranges "$hp_core")
com.k7k7.goujihd.huawei{AudioTrack}=$(format_cpu_ranges "$p_core")
com.k7k7.goujihd.huawei{binder*}=$(format_cpu_ranges "$p_core")
com.k7k7.goujihd.huawei{Thread*}=$(format_cpu_ranges "$p_core")
com.k7k7.goujihd.huawei=$(format_cpu_ranges "$e_core $p_core")

# 暗区突围
com.tencent.mf.uam{GameThread}=$(format_cpu_ranges "$hp_core")
com.tencent.mf.uam{RenderThread*}=$(format_cpu_ranges "$p_core")
com.tencent.mf.uam{RHIThread}=$(format_cpu_ranges "$p_core")
com.tencent.mf.uam{com.tencent.mf.uam}=$(format_cpu_ranges "$p_core")
com.tencent.mf.uam=$(format_cpu_ranges "$e_core $p_core")

# 枪火重生
com.duoyi.m2m1{UnityMain}=$(format_cpu_ranges "$hp_core")
com.duoyi.m2m1{UnityGfxDeviceW}=$(format_cpu_ranges "$p_core")
com.duoyi.m2m1{Job.Worker}=$(format_cpu_ranges "$p_core")
com.duoyi.m2m1{NativeThread }=$(format_cpu_ranges "$p_core")
com.duoyi.m2m1{AudioTrack}=$(format_cpu_ranges "$p_core")
com.duoyi.m2m1=$(format_cpu_ranges "$ e_core $p_core")