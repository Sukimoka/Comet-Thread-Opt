MODDIR="${0%/*}"
UPDATE_TIME=$(date +"%m月%d日%H:%M")
CONF_FILE1="$MODDIR/applist1.conf.temp"
CONF_FILE2="$MODDIR/applist2.conf.temp"
TIME_FILE="$MODDIR/time.txt"

URL1="https://raw.githubusercontent.com/Sukimoka/Comet-Thread-Opt/main/app/App_8G3.txt"
URL2="https://raw.githubusercontent.com/Sukimoka/Comet-Thread-Opt/main/game/Game_8G3.txt"
API_URL="https://api.github.com/repos/Sukimoka/Comet-Thread-Opt/commits?sha=main"

download_file() {
    local url="$1"
    local conf_file="$2"
    if command -v curl >/dev/null 2>&1; then
        curl -s -k -L -A "Mozilla/5.0" -H "Accept: application/vnd.github.v3+json" -o "$conf_file" "$url"
    elif command -v wget >/dev/null 2>&1; then
        wget -q --no-check-certificate -U "Mozilla/5.0" -O "$conf_file" "$url"
    else
        echo "错误❌,下载失败:未找到 curl 或 wget。"
        exit 1
    fi
    
    if [ $? -ne 0 ] || [ ! -s "$conf_file" ]; then
        rm -f "$conf_file"
        exit 1
    fi
}

# 读取上次更新时间
if [ -f "$TIME_FILE" ]; then
    LAST_UPDATE=$(cat "$TIME_FILE" | sed 's/ UTC$//')
    # 转换为ISO 8601格式 (YYYY-MM-DDTHH:MM:SSZ)
    SINCE_TIME=$(echo "$LAST_UPDATE" | sed 's/ /T/')Z
else
    LAST_UPDATE=""
    SINCE_TIME=""
fi

# 配置文件更新
download_file "$URL1" "$CONF_FILE1"
download_file "$URL2" "$CONF_FILE2"
cat "$CONF_FILE1" "$CONF_FILE2" > "$MODDIR/applist.conf"
rm -f "$CONF_FILE1" "$CONF_FILE2"

# 更新时间
sed -i "/^description=/ s/ 配置时间.*$//" "$MODDIR/module.prop"
sed -i "/^description=/ s/$/ 配置时间$UPDATE_TIME/" "$MODDIR/module.prop"
UTC_TIME=$(date -u +"%Y-%m-%d %H:%M:%S")
echo "$UTC_TIME UTC" > "$TIME_FILE"

echo "-------------------------------------"
echo "已成功更新 applist1"
echo "已成功更新 applist2"
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
NEW_COMMITS=$(curl -skLA "Mozilla/5.0" "$FETCH_URL" | grep -Eo '"message":"[^"]*"' | sed 's/"message":"//;s/"//g' | grep -E "(App|Game)\:")

if [ -n "$NEW_COMMITS" ]; then
    echo "$NEW_COMMITS" | head -n 6
else
    echo "暂无新更新"
fi

echo "${message}"
echo "-------------------------------------"
echo "🎉 配置更新完成"

sleep 2