MODDIR="${0%/*}"
CONF_FILE="$MODDIR/applist.conf.temp"
UPDATE_TIME=$(date +"%m月%d日%H:%M")

URL="https://raw.githubusercontent.com/Sukimoka/Comet-Thread-Opt/main/app/applist.conf"

if command -v curl >/dev/null 2>&1; then
    curl -s -o "$CONF_FILE" "$URL"
elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$CONF_FILE" "$URL"
else
    echo "错误，文件获取失败."
    exit 1
fi

if [ $? -eq 0 ] && [ -s "$CONF_FILE" ]; then
    mv "$CONF_FILE" "$MODDIR/applist.conf"
    
    sed -i "/^description=/ s/ 配置时间.*$//" "$MODDIR/module.prop"

    sed -i "/^description=/ s/$/ 配置时间$UPDATE_TIME/" "$MODDIR/module.prop"
    
    echo "线程配置更新成功"
else
    rm -f "$CONF_FILE"
    echo "错误❌，下载失败"
    exit 1
fi
