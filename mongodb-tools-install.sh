#!/bin/bash

# MongoDB 工具版本
MONGODB_TOOLS_VERSION="100.12.0"

# 安装目录
MONGOSH_INSTALL_DIR="/usr/local/mongotools"
rm -rf $MONGOSH_INSTALL_DIR
mkdir -p $MONGOSH_INSTALL_DIR

echo "开始安装 MongoDB 工具..."

# 解压并安装 MongoDB 工具
echo "正在安装 MongoDB 工具..."
tar -zxvf $PWD/lib/mongodb-database-tools-rhel70-x86_64-${MONGODB_TOOLS_VERSION}.tgz
mv -f $PWD/mongodb-database-tools-rhel70-x86_64-${MONGODB_TOOLS_VERSION}/bin/* $MONGOSH_INSTALL_DIR
rm -rf $PWD/mongodb-database-tools-rhel70-x86_64-${MONGODB_TOOLS_VERSION}

# 添加环境变量
echo "配置环境变量..."
cat > /etc/profile.d/mongotools.sh << EOF
export PATH=\$PATH:${MONGOSH_INSTALL_DIR}
EOF
source /etc/profile.d/mongotools.sh

# 验证安装
echo "验证安装..."
echo "mongodump 版本: " $(mongodump --version)
echo "mongorestore 版本: " $(mongorestore --version)
echo "mongoexport 版本: " $(mongoexport --version)
echo "mongoimport 版本: " $(mongoimport --version)

echo "MongoDB 工具安装完成！"