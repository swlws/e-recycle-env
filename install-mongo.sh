#!/bin/bash

# 远程服务器信息
MONGODB_VERSION="7.0.12"
MONGOSH_VERSION="2.2.12"

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then 
    echo "请使用 root 用户运行此脚本"
    exit 1
fi

CURRENT_DIR=$PWD
# 创建必要的目录
echo "创建必要的目录..."
MONGODB_INSTALL_DIR="/usr/local/mongodb"
rm -rf $MONGODB_INSTALL_DIR
mkdir -p $MONGODB_INSTALL_DIR

MONGOSH_INSTALL_DIR="/usr/local/mongosh"
rm -rf $MONGOSH_INSTALL_DIR
mkdir -p $MONGOSH_INSTALL_DIR

mkdir -p /var/lib/mongodb
mkdir -p /var/log/mongodb
mkdir -p /var/run/mongodb

# 创建 mongodb 用户和用户组
echo "创建 mongodb 用户..."
useradd -r -s /sbin/nologin mongod

# 解压并安装 MongoDB
echo "正在安装 MongoDB..."
tar -zxvf $CURRENT_DIR/lib/mongodb-linux-x86_64-rhel70-${MONGODB_VERSION}.gz
mv -f $CURRENT_DIR/mongodb-linux-x86_64-rhel70-${MONGODB_VERSION}/* $MONGODB_INSTALL_DIR
rm -rf $CURRENT_DIR/mongodb-linux-x86_64-rhel70-${MONGODB_VERSION}

# 设置目录权限
chmod 755 /var/lib/mongodb
chmod 755 /var/log/mongodb

# 创建 MongoDB 配置文件
echo "创建配置文件..."
cat > /etc/mongod.conf << EOF
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log
storage:
  dbPath: /var/lib/mongodb
processManagement:
  fork: true
  pidFilePath: /var/run/mongod.pid
  timeZoneInfo: /usr/share/zoneinfo
net:
  port: 27017
  bindIp: 0.0.0.0
security:
  authorization: disabled
EOF

# 创建 systemd 服务文件
echo "创建系统服务..."
cat > /lib/systemd/system/mongodb.service << EOF
[Unit]
Description=mongodb
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
ExecStart=${MONGODB_INSTALL_DIR}/bin/mongod --config /etc/mongod.conf
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=${MONGODB_INSTALL_DIR}/bin/mongod --shutdown --config /etc/mongod.conf
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

# 添加环境变量
echo "配置环境变量..."
cat > /etc/profile.d/mongodb.sh << EOF
export PATH=\$PATH:${MONGODB_INSTALL_DIR}/bin
EOF
source /etc/profile.d/mongodb.sh

# 安装 Mongosh
echo "正在安装 Mongosh..."
tar -zxvf $CURRENT_DIR/lib/mongosh-${MONGOSH_VERSION}-linux-x64.tgz
mv -f $CURRENT_DIR/mongosh-${MONGOSH_VERSION}-linux-x64/* $MONGOSH_INSTALL_DIR
rm -rf $CURRENT_DIR/mongosh-${MONGOSH_VERSION}-linux-x64

# 添加环境变量
echo "配置环境变量..."
cat > /etc/profile.d/mongosh.sh << EOF
export PATH=\$PATH:${MONGOSH_INSTALL_DIR}/bin
EOF
source /etc/profile.d/mongosh.sh

# 设置服务权限
chmod 755 /lib/systemd/system/mongodb.service

# 启动 MongoDB 服务
echo "启动服务..."
systemctl daemon-reload
systemctl start mongodb.service
systemctl enable mongodb.service

# 等待服务启动
sleep 5

# 初始化管理员用户
echo "创建管理员用户..."
mongosh --eval '
  use admin;
  db.createUser({
    user: "admin",
    pwd: "admin@swlws!!!",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  });
'

# 启用安全认证
echo "启用安全认证..."
sed -i 's/authorization: disabled/authorization: enabled/' /etc/mongod.conf

# 重启服务以应用安全设置
systemctl restart mongodb.service

sleep 5

# 创建应用数据库和用户
echo "创建应用数据库用户..."
mongosh --eval '
  use admin;
  db.auth("admin", "admin@swlws!!!");
  use swlws;
  db.createUser({
    user: "swlws",
    pwd: "swlws@123!!!",
    roles: [{ role: "readWrite", db: "swlws" }]
  });
'

# 开放防火墙端口
echo "配置防火墙..."
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --zone=public --add-port=27017/tcp --permanent
firewall-cmd --reload

# 验证安装
echo "验证安装..."
mongosh --version
mongod --version

echo "检查服务状态..."
systemctl status mongodb.service

echo "MongoDB 安装完成！"
echo "管理员用户: admin"
echo "应用数据库用户: swlws"
echo "请使用以下命令测试连接："
echo "管理员连接: mongosh \"mongodb://127.0.0.1:27017\" --username admin --authenticationDatabase admin"
echo "应用用户连接: mongosh \"mongodb://127.0.0.1:27017/swlws\" --username swlws"