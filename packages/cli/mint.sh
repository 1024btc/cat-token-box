#!/bin/bash

# https://mempool.fractalbitcoin.io/api/v1/fees/recommended
# bash 请求 fee

# 获取用户设置的mint次数
read -p "请输入 mint 次数: " MINT_COUNT

response=$(curl -s https://mempool.fractalbitcoin.io/api/v1/fees/recommended)

# 经济的gas文案
# response=$(curl -s https://mempool.fractalbitcoin.io/api/v1/fees/mempool-blocks)
# feeRate=$(echo $response | jq '.[0].feeRange | .[2]') # 倒数第三档

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

for ((i=1; i<=MINT_COUNT; i++)); do

    $command

    if [ $? -ne 0 ]; then
        echo "命令执行失败，退出循环"
        exit 1
    fi

    sleep 1
done


echo "所有 mint 操作完成"