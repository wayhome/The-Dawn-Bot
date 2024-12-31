#!/bin/bash
set -e

# 检查必需的环境变量
if [ -z "$DAWN_EMAIL" ] || [ -z "$DAWN_PASSWORD" ] || [ -z "$DAWN_2CAPTCHA_KEY" ]; then
    echo "错误: 必需的环境变量未设置"
    echo "请设置: DAWN_EMAIL, DAWN_PASSWORD, DAWN_2CAPTCHA_KEY"
    exit 1
fi

# 更新settings.yaml中的2captcha key
sed -i "s/two_captcha_api_key: .*/two_captcha_api_key: \"$DAWN_2CAPTCHA_KEY\"/" config/settings.yaml

# 写入账户信息到farm.txt
echo "${DAWN_EMAIL}:${DAWN_PASSWORD}" > config/data/farm.txt

# 如果设置了代理,则写入proxies.txt
if [ ! -z "$DAWN_PROXY" ]; then
    echo "$DAWN_PROXY" > config/data/proxies.txt
fi

# 执行主命令
exec "$@" 