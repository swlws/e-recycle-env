#!/bin/bash

# === 配置区域 ===
# 远程服务器信息
REMOTE_USER="root"
REMOTE_HOST="your.server.com"
LOCAL_CERT_DIR="$PWD/cert"
REMOTE_DIR="$pwd/root/e-recycle-env/cert"

# === 步骤 1: 上传文件 ===
echo "开始上传证书文件..."

scp -r "${LOCAL_CERT_DIR}/"* "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}"

if [ $? -eq 0 ]; then
    echo "✅ 上传完成，文件已覆盖旧版本。"
else
    echo "❌ 上传失败，请检查连接与路径设置。"
fi


# === 步骤 2: 检查 nginx 配置 ===
echo "🔍 在远程服务器上执行 nginx -t 进行配置校验..."

ssh "${REMOTE_USER}@${REMOTE_HOST}" "nginx -t"
if [ $? -ne 0 ]; then
  echo "❌ nginx 配置错误，请修复后重试。"
  exit 1
fi
echo "✅ nginx 配置检查通过。"

# === 步骤 3: 重启 nginx ===
echo "♻️ 重启 nginx 服务..."

ssh "${REMOTE_USER}@${REMOTE_HOST}" "systemctl restart nginx"
if [ $? -ne 0 ]; then
  echo "❌ nginx 重启失败，请手动检查。"
  exit 1
fi

echo "🎉 所有操作成功完成。"