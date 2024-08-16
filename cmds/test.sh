#!/bin/bash

# 目标URL
URL="https://azfwtest.chenghx.biz"

# 循环间隔时间（秒）
INTERVAL=1

# 无限循环
while true
do
    # 执行curl请求
    RESPONSE=$(curl -A "HaxerMen"  -s -o /dev/null -w "%{http_code}" $URL)
    
    # 打印时间戳和响应状态码
    echo "$(date): HTTP Status Code: $RESPONSE"
    
    # 等待指定的间隔时间
    sleep $INTERVAL
done

