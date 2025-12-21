#!/bin/bash

echo ""
echo "#######################################################################"
echo "#                          Ubuntu初始化脚本 Ubuntu 24                  #"
echo "#                          Ubuntu 24.04.3 LTS                         #"
echo "#                          Stage - 1 初始化                            #"
echo "#######################################################################"
echo ""

# 配置镜像
config_mirror() {
    echo "配置国内镜像源..."

    # 备份原始源文件
    if [ -f /etc/apt/sources.list ]; then
        sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
    fi

    # 创建目录
    sudo mkdir -p /etc/apt/sources.list.d

    # 方法1：使用 Debian 822 格式（.sources 文件）
    SOURCE_FILE="/etc/apt/sources.list.d/ubuntu.sources"

    if [ -f "$SOURCE_FILE" ]; then
        sudo cp "$SOURCE_FILE" "$SOURCE_FILE.bak"
        echo "已备份原文件为: $SOURCE_FILE.bak"
    fi

    # 写入正确的 Debian 822 格式
    sudo cp ./config/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources
    echo "镜像源已成功写入到 $SOURCE_FILE（使用Deb822格式）"

    # 更新软件包列表
    echo "更新软件包列表..."
    sudo apt-get update -y
}

# 要安装的内容
INSTALL_FUNCTION=(
    config_mirror
)

for func in "${INSTALL_FUNCTION[@]}"; do
    echo ""
    echo "========================================"
    echo "正在执行: $func"
    echo "========================================"

    # 执行函数并记录结果
    if $func; then
        echo "✓ 执行成功: $func"
    else
        echo "✗ 执行失败: $func"
    fi
done
