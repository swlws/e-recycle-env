#!/bin/bash

# 远程服务器信息
REMOTE_HOST="root@127.0.0.1"
REMOTE_DIR="/root/e-recycle-env"

# 创建远程目录
echo "创建远程目录..."
ssh $REMOTE_HOST "mkdir -p ${REMOTE_DIR}"

# 使用 rsync 上传所有文件，排除 upload.sh
echo "上传文件中..."
rsync -avz --progress \
    --exclude 'upload.sh' \
    --exclude '.git' \
    --exclude '.gitignore' \
    ./ $REMOTE_HOST:${REMOTE_DIR}/

# 设置脚本权限
echo "设置脚本权限..."
ssh $REMOTE_HOST "chmod +x ${REMOTE_DIR}/install.sh"

echo "文件上传完成！"
echo "你现在可以通过 SSH 连接到服务器并运行安装脚本："
echo "ssh $REMOTE_HOST"
echo "cd ${REMOTE_DIR} && ./install.sh"