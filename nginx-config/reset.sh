#!/bin/bash

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then 
    echo "请使用 root 用户运行此脚本"
    exit 1
fi

# Nginx 配置目录
NGINX_CONF_DIR="/etc/nginx"
CURRENT_DIR="$PWD/nginx-config"

chmod 600 /root/e-recycle-env/cert/swlws.site_bundle.crt
chmod 600 /root/e-recycle-env/cert/swlws.site.key

echo "开始覆盖 Nginx 配置..."

# 备份原有配置
echo "备份原有配置..."
BACKUP_TIME=$(date +%Y%m%d_%H%M%S)
if [ -d "$NGINX_CONF_DIR" ]; then
    tar -czf "/tmp/nginx_backup_${BACKUP_TIME}.tar.gz" "$NGINX_CONF_DIR"
    echo "原配置已备份到 /tmp/nginx_backup_${BACKUP_TIME}.tar.gz"
fi

# 创建必要的目录
echo "创建必要的目录..."
mkdir -p "$NGINX_CONF_DIR/conf.d"

# 复制配置文件
echo "复制配置文件..."
cp "$CURRENT_DIR/nginx.conf" "$NGINX_CONF_DIR/nginx.conf"
cp "$CURRENT_DIR/conf.d/"* "$NGINX_CONF_DIR/conf.d/"

# 设置正确的权限
echo "设置文件权限..."
chown -R root:root "$NGINX_CONF_DIR"
chmod 644 "$NGINX_CONF_DIR/nginx.conf"
chmod 644 "$NGINX_CONF_DIR/conf.d/"*

# 测试配置
echo "测试 Nginx 配置..."
nginx -t

if [ $? -eq 0 ]; then
    echo "配置测试通过，重新加载 Nginx..."
    nginx -s reload
    echo "✅ Nginx 配置已更新并重新加载！"
else
    echo "❌ 配置测试失败，回滚到备份配置..."
    cd /tmp && tar -xzf "nginx_backup_${BACKUP_TIME}.tar.gz"
    cp -r /tmp/etc/nginx/* "$NGINX_CONF_DIR/"
    nginx -s reload
    echo "已回滚到原配置"
    exit 1
fi