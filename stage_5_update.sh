#!/bin/bash

echo "#######################################################################"
echo "#                          Ubuntu初始化脚本 Ubuntu 24                  #"
echo "#                          Ubuntu 24.04.3 LTS                         #"
echo "#                          Stage - 4 更新系统                          #"
echo "#######################################################################"
echo ""

# 更新系统
update_system() {
    echo "更新系统..."
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt atuoremove
    sleep 3
}

# 配置Wine
install_wine_config() {
    echo "配置Wine..."

    echo "Wine配置完成，可手动运行：winecfg"
}

# 执行其他函数
INSTALL_FUNCTIONS=(
    update_system
    install_wine_config
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
