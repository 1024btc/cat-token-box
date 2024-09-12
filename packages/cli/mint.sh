#!/bin/bash

# https://mempool.fractalbitcoin.io/api/v1/fees/recommended
# bash 请求 fee

while true; do
    response=$(curl -s https://mempool.fractalbitcoin.io/api/v1/fees/recommended)
    feeRate=$(echo $response | jq '.fastestFee')
    echo $feeRate

    # 如果没有获取到 feeRate，使用config里面max的配置
    if [ -z "$feeRate" ] || [ "$feeRate" == "null" ]; then
        feeRate=''
    else
        feeRate='--fee-rate '$feeRate
    fi

    echo $feeRate
    command="yarn cli mint -i 45ee725c2c5993b3e4d308842d87e973bf1951f5f7a804b21e4dd964ecd12d6b_0 5 $feeRate"
    $command

    if [ $? -ne 0 ]; then
        echo "命令执行失败，退出循环"
        exit 1
    fi

    sleep 1
done