#!/bin/bash

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then 
    echo "请使用 root 用户运行此脚本"
    exit 1
fi

# 检查是否已安装 Nginx
echo "检查是否已安装 Nginx..."
if command -v nginx >/dev/null 2>&1; then
    echo "Nginx 已安装，当前版本："
    nginx -v
    echo "是否要重新安装？[y/N]"
    read -r answer
    if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
        echo "安装已取消"
        exit 0
    fi
    echo "继续安装..."
fi

echo "开始安装 Nginx..."

# 添加 Nginx 官方源
echo "添加 Nginx 官方源..."
cat > /etc/yum.repos.d/nginx.repo << EOF
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF

# 安装 Nginx
echo "安装 Nginx..."
yum install -y nginx

# 启动 Nginx 服务
echo "启动服务..."
systemctl start nginx
systemctl enable nginx

# 配置防火墙
echo "配置防火墙..."
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

# 验证安装
echo "验证安装..."
nginx -v
systemctl status nginx

echo "Nginx 安装完成！"
echo "可以通过以下命令管理 Nginx 服务："
echo "启动：systemctl start nginx"
echo "停止：systemctl stop nginx"
echo "重启：systemctl restart nginx"
echo "重新加载配置：systemctl reload nginx"
echo "查看状态：systemctl status nginx"

