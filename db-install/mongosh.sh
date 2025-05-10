#!/bin/bash

# MongoDB Shell 版本
MONGOSH_VERSION="2.2.12"

# 安装目录
MONGOSH_INSTALL_DIR="/usr/local/mongosh"
rm -rf $MONGOSH_INSTALL_DIR
mkdir -p $MONGOSH_INSTALL_DIR

echo "开始安装 MongoDB Shell..."

# 解压并安装 Mongosh
echo "正在安装 Mongosh..."
tar -zxvf $PWD/lib/mongosh-${MONGOSH_VERSION}-linux-x64.tgz
mv -f $PWD/mongosh-${MONGOSH_VERSION}-linux-x64/* $MONGOSH_INSTALL_DIR
rm -rf $PWD/mongosh-${MONGOSH_VERSION}-linux-x64

# 添加环境变量
echo "配置环境变量..."
cat > /etc/profile.d/mongosh.sh << EOF
export PATH=\$PATH:${MONGOSH_INSTALL_DIR}/bin
EOF
source /etc/profile.d/mongosh.sh

# 验证安装
echo "验证安装..."
echo "Mongosh 版本: " $(mongosh --version)

echo "MongoDB Shell 安装完成！"