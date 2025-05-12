#!/bin/bash

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then
    echo "请使用 root 用户运行此脚本"
    exit 1
fi

# 检查 nginx
if ! command -v nginx &> /dev/null; then
    echo "未找到 nginx，正在安装..."
    apt-get update
    apt-get install -y nginx
    echo "nginx 安装完成"
else
    echo "nginx 已安装"
fi

