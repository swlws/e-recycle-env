#!/bin/bash

# 定义服务器选项数组
options=(
    "dev - root@dev.swlws.site"
    "prod - root@swlws.site"
)

# 显示服务器列表
echo "可用的服务器列表（共 ${#options[@]} 个）："
PS3="请选择目标服务器 [1-${#options[@]}]: "

# 使用 select 进行选择
select choice in "${options[@]}"; do
    if [ -n "$choice" ]; then
        # 解析选择的服务器信息
        SERVER_KEY=$(echo $choice | cut -d'-' -f1 | xargs)
        REMOTE_HOST=$(echo $choice | cut -d'-' -f2 | xargs)
        break
    else
        echo "错误：无效的选择，请输入 1 到 ${#options[@]} 之间的数字"
    fi
done

# 设置远程目录
REMOTE_DIR="/root/e-recycle-env"

echo "已选择服务器: $REMOTE_HOST ($SERVER_KEY)"

# 创建远程目录
echo "创建远程目录..."
ssh $REMOTE_HOST "mkdir -p ${REMOTE_DIR}"

# 使用 rsync 上传所有文件，排除不需要的文件
echo "上传文件中..."
rsync -avz --progress \
    --exclude 'upload.sh' \
    --exclude '.git' \
    --exclude '.gitignore' \
    --exclude 'node_modules' \
    --exclude '*.log' \
    ./ $REMOTE_HOST:${REMOTE_DIR}/

# 设置脚本权限
echo "设置脚本权限..."
ssh $REMOTE_HOST "chmod +x ${REMOTE_DIR}/*.sh"

echo "✅ 文件上传完成！"
echo "你现在可以通过 SSH 连接到服务器并运行安装脚本："
echo "ssh $REMOTE_HOST"
echo "cd ${REMOTE_DIR} && ./install.sh"