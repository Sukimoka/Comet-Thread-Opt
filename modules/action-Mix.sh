MODDIR="${0%/*}"
UPDATE_TIME=$(date +"%m月%d日%H:%M")
CONF_FILE1="$MODDIR/applist1.conf.temp"
CONF_FILE2="$MODDIR/applist2.conf.temp"

URL1="https://raw.githubusercontent.com/Sukimoka/Comet-Thread-Opt/2d85959170fa4a2c243044cfb41fd5cd21871366/app/applist.conf"
URL2="https://raw.githubusercontent.com/Sukimoka/Comet-Thread-Opt/2d85959170fa4a2c243044cfb41fd5cd21871366/game/applist.conf"

download_file() {
    local url="$1"
    local conf_file="$2"
    if command -v curl >/dev/null 2>&1; then
        curl -s -o "$conf_file" "$url"
    elif command -v wget >/dev/null 2>&1; then
        wget -q -O "$conf_file" "$url"
    else
        echo "错误❌，下载失败"
        exit 1
    fi
    if [ $? -ne 0 ] || [ ! -s "$conf_file" ]; then
        rm -f "$conf_file"
        echo "错误，文件获取失败."
        exit 1
    fi
}

download_file "$URL1" "$CONF_FILE1"
download_file "$URL2" "$CONF_FILE2"

cat "$CONF_FILE1" "$CONF_FILE2" > "$MODDIR/applist.conf"

rm -f "$CONF_FILE1" "$CONF_FILE2"

sed -i "/^description=/ s/ 配置时间.*$//" "$MODDIR/module.prop"

sed -i "/^description=/ s/$/ 配置时间$UPDATE_TIME/" "$MODDIR/module.prop"

echo "线程配置更新成功"
