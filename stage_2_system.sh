#!/bin/bash

echo ""
echo "#######################################################################"
echo "#                          Ubuntu初始化脚本 Ubuntu 24                  #"
echo "#                          Ubuntu 24.04.3 LTS                         #"
echo "#                          Stage - 2 系统环境                          #"
echo "#######################################################################"
echo ""

# 安装默认内容
install_default_package() {
    echo "安装默认软件包..."

    sudo apt-get update -y

    # 安装curl
    sudo apt install curl

    # 安装SSH
    sudo apt install ssh -y

    # 安装htop
    sudo apt install htop -y

    # 安装常用压缩工具
    sudo apt install zip unzip p7zip-full unrar tar gzip bzip2 xz-utils -y

    # 可视化的清理和管理
    sudo apt install stacer -y

    echo "默认软件包安装完成！"
}

# 安装 LibreOffice
install_libreoffice() {
    echo "安装LibreOffice..."
    sudo apt update  -y
    sudo apt install libreoffice libreoffice-l10n-zh-cn -y
}

# 安装VLC
install_VLC() {
    echo "安装VLC..."
    sudo apt update -y
    sudo apt install vlc -y
}

# 安装Fcitx5
install_fcitx5() {
    echo "安装Fcitx5中文输入法..."

    # 安装Fcitx5
    sudo apt install fcitx5 \
        fcitx5-chinese-addons \
        fcitx5-frontend-gtk4 \
        fcitx5-frontend-gtk3 \
        fcitx5-frontend-qt5 \
        -y

    echo "Fcitx5安装完成，请重启后配置"
}

# 安装Wine
install_wine() {
    echo "安装Wine..."

    # 启用32位架构
    sudo dpkg --add-architecture i386

    # 下载并添加密钥
    sudo mkdir -p /etc/apt/keyrings
    wget -O- https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /etc/apt/keyrings/winehq.gpg

    # 添加仓库
    echo "deb [signed-by=/etc/apt/keyrings/winehq.gpg] https://dl.winehq.org/wine-builds/ubuntu/ noble main" | sudo tee /etc/apt/sources.list.d/wine.list

    sudo apt update  -y

    # 安装Wine
    sudo apt install --install-recommends winehq-stable -y

    # 验证安装
    wine --version 2>/dev/null || echo "Wine安装可能需要更多步骤"
}

# 安装Wine扩展
install_wine_extend() {
    echo "安装Wine扩展..."

    # 安装winetricks
    sudo apt install winetricks -y

    echo "Wine扩展安装完成，可手动运行：winetricks corefonts"
}

# 执行其他函数
INSTALL_FUNCTIONS=(
    install_default_package
    # install_libreoffice
    install_VLC
    install_fcitx5
    install_wine
    install_wine_extend
)

for func in "${INSTALL_FUNCTIONS[@]}"; do
    echo ""
    echo "========================================"
    echo "正在执行: $func"
    echo "========================================"

    # 执行函数并记录结果
    if $func; then
        echo "✓ 执行成功: $func"
    else
        echo "✗ 执行失败: $func"
        read -p "是否继续执行下一个？(y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "用户取消"
            exit 1
        fi
    fi
done
