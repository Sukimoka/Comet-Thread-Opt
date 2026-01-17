MODDIR="${0%/*}"
UPDATE_TIME=$(date +"%m月%d日%H:%M")
CONF_FILE1="$MODDIR/applist1.conf.temp"
CONF_FILE2="$MODDIR/applist2.conf.temp"
CHANGELOG_FILE="$MODDIR/ChangeLog.txt.temp"

# 配置文件下载的 raw URL
URL1="https://raw.githubusercontent.com/Sukimoka/Comet-Thread-Opt/main/app/App_8G3.txt"
URL2="https://raw.githubusercontent.com/Sukimoka/Comet-Thread-Opt/main/game/Game_8G3.txt"
# ChangeLog.txt 的 raw URL
CHANGELOG_URL="https://raw.githubusercontent.com/Sukimoka/Comet-Thread-Opt/master/ChangeLog.txt"

download_file() {
    local url="$1"
    local conf_file="$2"
    echo "正在下载： $(basename "$conf_file")"
    if command -v curl >/dev/null 2>&1; then
        curl -s -L -o "$conf_file" "$url"
    elif command -v wget >/dev/null 2>&1; then
        wget -q -O "$conf_file" "$url"
    else
        echo "错误❌，下载失败：未找到 curl 或 wget。"
        exit 1
    fi
    
    if [ $? -ne 0 ] || [ ! -s "$conf_file" ]; then
        rm -f "$conf_file"
        echo "错误❌，文件 $(basename "$conf_file") 获取失败."
        if [ "$conf_file" != "$CHANGELOG_FILE" ]; then
            exit 1
        fi
        echo "⚠️ ChangeLog 下载失败，将跳过显示。"
    fi
}

# 下载配置文件
download_file "$URL1" "$CONF_FILE1"
download_file "$URL2" "$CONF_FILE2"

# 合并配置文件
cat "$CONF_FILE1" "$CONF_FILE2" > "$MODDIR/applist.conf"

# 清理临时配置文件
rm -f "$CONF_FILE1" "$CONF_FILE2"

# 更新 module.prop 中的时间
sed -i "/^description=/ s/ 配置时间.*$//" "$MODDIR/module.prop"
sed -i "/^description=/ s/$/ 配置时间$UPDATE_TIME/" "$MODDIR/module.prop"

# 5. 下载 ChangeLog
download_file "$CHANGELOG_URL" "$CHANGELOG_FILE"

# 显示更新信息和 ChangeLog
echo "-------------------------------------"
echo "线程配置更新成功 ✅"
echo "配置更新完成"
echo "-------------------------------------"

if [ -s "$CHANGELOG_FILE" ]; then
    echo "ChangeLog:"
    cat "$CHANGELOG_FILE"
else
    echo "ChangeLog: (文件未找到或下载失败)"
fi

# 清理临时 ChangeLog 文件
rm -f "$CHANGELOG_FILE"

sleep 2
