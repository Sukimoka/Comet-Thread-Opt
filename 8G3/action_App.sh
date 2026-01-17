MODDIR="${0%/*}"
UPDATE_TIME=$(date +"%m月%d日%H:%M")
APPLIST_FILE="$MODDIR/applist.conf"
CHANGELOG_TEMP="$MODDIR/ChangeLog.txt.temp"

# 配置文件和 ChangeLog 的 raw URL
URL_APPLIST="https://raw.githubusercontent.com/Sukimoka/Comet-Thread-Opt/main/app/App_8G3.txt"
URL_CHANGELOG="https://raw.githubusercontent.com/Sukimoka/Comet-Thread-Opt/master/ChangeLog.txt"

# 检查下载工具并执行下载
download_file() {
    local url="$1"
    local output="$2"
    local filename=$(basename "$output")
    
    echo "正在下载： $filename"
    
    if command -v curl >/dev/null 2>&1; then
        curl -s -L -f -o "$output" "$url"
    elif command -v wget >/dev/null 2>&1; then
        wget -q -O "$output" "$url"
    else
        echo "错误❌，下载失败：未找到 curl 或 wget。"
        exit 1
    fi
    
    if [ $? -ne 0 ] || [ ! -s "$output" ]; then
        rm -f "$output"
        echo "错误❌，文件 $filename 获取失败."
        if [ "$output" = "$APPLIST_FILE" ]; then
            exit 1
        fi
        echo "⚠️ ChangeLog 下载失败，将跳过显示。"
        return 1
    fi
    return 0
}

# 下载 Applist 配置文件
download_file "$URL_APPLIST" "$APPLIST_FILE" || exit 1 # 如果 applist 下载失败，则终止脚本

# 更新 module.prop 中的时间
sed -i "/^description=/ s/ 配置时间.*$//" "$MODDIR/module.prop"
sed -i "/^description=/ s/$/ 配置时间$UPDATE_TIME/" "$MODDIR/module.prop"

# 下载 ChangeLog
download_file "$URL_CHANGELOG" "$CHANGELOG_TEMP"
LOG_DOWNLOADED=$?

# 4. 显示更新信息和 ChangeLog
echo "-------------------------------------"
echo "线程配置更新成功 ✅"
echo "配置更新完成：$UPDATE_TIME"
echo "-------------------------------------"

if [ $LOG_DOWNLOADED -eq 0 ]; then
    echo "ChangeLog:"
    cat "$CHANGELOG_TEMP"
else
    echo "ChangeLog: (文件未找到或下载失败)"
fi

# 清理临时文件
rm -f "$CHANGELOG_TEMP"

# 暂停
sleep 2
