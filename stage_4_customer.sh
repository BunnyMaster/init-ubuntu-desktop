echo ""
echo "#######################################################################"
echo "#                          Ubuntu初始化脚本 Ubuntu 24                  #"
echo "#                          Ubuntu 24.04.3 LTS                         #"
echo "#                          自定义内容 Customer                         #"
echo "#######################################################################"
echo ""

echo "设置自定义内容..."

# TODO 你的函数
demo_func() {
    echo "你的函数"
}

# 执行其他函数
INSTALL_FUNCTIONS=(
    demo_func
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
