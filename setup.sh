#!/bin/bash

echo ""
echo "#######################################################################"
echo "#                          Ubuntu初始化脚本 Ubuntu 24                  #"
echo "#                          Ubuntu 24.04.3 LTS                         #"
echo "#######################################################################"
echo ""

# 检查是否以sudo运行
if [ "$EUID" -eq 0 ]; then
    echo "错误：请不要使用sudo直接运行此脚本"
    echo "请使用普通用户运行：bash install.sh"
    exit 1
fi

# 询问用户是否继续
read -p "是否继续执行初始化脚本？(y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "用户取消"
    exit 0
fi

# ==================== 主程序开始 ====================F

# 为所有脚本添加可执行
chmod +x *.sh

# 执行顺序
STAGES=(
    "stage_1_init.sh"
    "stage_2_system.sh"
    "stage_3_development.sh"
    "stage_4_customer.sh"
    "stage_5_update.sh"
)

for stage in "${STAGES[@]}"; do
    # 记录开始时间
    START_TIME=$(date +%s)

    if [ -f "$stage" ]; then
        echo "========================================"
        echo "执行: $stage"
        echo "========================================"
        bash "$stage"
    else
        echo "警告: $stage 不存在，跳过"
    fi

    # 计算执行时间
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))

    echo ""
    echo "###################################################"
    echo "#                  脚本执行完成！                  #"
    echo "#           总耗时: $((DURATION / 60))分$((DURATION % 60))秒          #"
    echo "###################################################"
    echo ""
done
