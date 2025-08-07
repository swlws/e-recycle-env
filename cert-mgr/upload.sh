#!/bin/bash

# === 配置区域 ===
# 远程服务器信息
REMOTE_USER="root"
REMOTE_HOST="your.server.com"
LOCAL_CERT_DIR="$PWD/cert"
REMOTE_DIR="$pwd/root/e-recycle-env/cert"

# === 执行上传 ===
echo "开始上传证书文件..."

scp -r "${LOCAL_CERT_DIR}/"* "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}"

if [ $? -eq 0 ]; then
    echo "✅ 上传完成，文件已覆盖旧版本。"
else
    echo "❌ 上传失败，请检查连接与路径设置。"
fi
