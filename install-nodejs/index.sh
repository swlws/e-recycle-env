#!/bin/bash

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then 
    echo "请使用 root 用户运行此脚本"
    exit 1
fi

# Node.js 版本
NODE_VERSION="16.20.0"

# 检查是否已安装 Node.js
if command -v node &> /dev/null; then
    INSTALLED_VERSION=$(node -v | cut -d 'v' -f2)
    echo "检测到已安装 Node.js v${INSTALLED_VERSION}"
    
    if [ "$INSTALLED_VERSION" = "$NODE_VERSION" ]; then
        echo "✅ 已安装所需版本，退出安装"
        exit 0
    else
        echo "当前版本：v${INSTALLED_VERSION}"
        echo "目标版本：v${NODE_VERSION}"
        echo "版本不一致，继续安装..."
    fi
fi

echo "开始安装 Node.js v${NODE_VERSION}..."

# 创建临时目录用于下载和解压
TEMP_DIR="$(pwd)/temp"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# 下载并解压 Node.js
echo "下载 Node.js..."
curl -O https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz

echo "解压 Node.js..."
tar -xf node-v${NODE_VERSION}-linux-x64.tar.xz
rm -f node-v${NODE_VERSION}-linux-x64.tar.xz

# 移动到安装目录
echo "安装 Node.js..."
rm -rf /usr/local/node
mv node-v${NODE_VERSION}-linux-x64 /usr/local/node

# 清理临时目录
cd ..
rm -rf "$TEMP_DIR"

# 创建软链接
echo "创建软链接..."
ln -sf /usr/local/node/bin/node /usr/bin/node
ln -sf /usr/local/node/bin/npm /usr/bin/npm
ln -sf /usr/local/node/bin/npx /usr/bin/npx

# 配置环境变量
echo "配置环境变量..."
PROFILE_FILE="/etc/profile.d/nodejs.sh"
echo 'export PATH=$PATH:/usr/local/node/bin' > "$PROFILE_FILE"
source "$PROFILE_FILE"

# 配置 npm 镜像源
echo "配置 npm 镜像源..."
npm config set registry https://registry.npmmirror.com

# 验证安装
echo "验证安装..."
node -v
npm -v

echo "✅ Node.js 安装完成！"
echo "Node.js 版本：$(node -v)"
echo "npm 版本：$(npm -v)"