#!/bin/bash

echo "#######################################################################"
echo "#                          Ubuntu初始化脚本 Ubuntu 24                  #"
echo "#                          Ubuntu 24.04.3 LTS                         #"
echo "#                          Stage - 3 开发环境                          #"
echo "#######################################################################"
echo ""

# 定义变量
GIT_USERNAME="your_username"
GIT_EMAIL="your_email"

# 安装Git
install_git() {
    echo "安装Git..."
    sudo apt install git -y

    echo "配置Git，用户名：$GIT_USERNAME，邮箱：$GIT_EMAIL"
    git config --global user.name "$GIT_USERNAME"
    git config --global user.email "$GIT_EMAIL"

    # 检查是否已有SSH密钥
    if [ ! -f ~/.ssh/id_rsa ]; then
        echo "生成SSH密钥..."
        ssh-keygen -t rsa -b 4096 -C "$GIT_EMAIL" -f ~/.ssh/id_rsa -N ""
    else
        echo "SSH密钥已存在，跳过生成"
    fi
}

# 安装Java
install_java() {
    echo "安装Java..."
    sudo apt update -y

    # 安装最新的Java
    echo "安装默认Java版本..."
    sudo apt install default-jdk -y

    # 尝试安装指定版本
    sudo apt install openjdk-21-jdk -y 2>/dev/null || echo "Java 21 不可用"
    sudo apt install openjdk-17-jdk -y 2>/dev/null || echo "Java 17 不可用"
    sudo apt install openjdk-8-jdk -y 2>/dev/null || echo "Java 8 不可用"

    echo "已安装的Java版本："
    java --version 2>/dev/null || echo "Java未安装成功"
}

# 安装Maven
install_maven() {
    echo "安装Maven..."
    sudo apt update -y

    sudo apt install maven -y

    mkdir -p ~/.m2/repository
    cp ./config/settings.xml /usr/share/maven/conf/settings.xml
    cp ./config/settings.xml ~/.m2/settings.xml

    echo "Maven 版本"
    mvn -v
}

# 安装Node.js
install_nodejs() {
    echo "安装Node.js..."
    sudo apt update -y

    # 安装Node.js和npm
    sudo apt install nodejs -y

    echo "Node.js版本："
    node --version

    # # 查看当前镜像
    # echo "当前npm镜像："
    # npm config get registry

    # # 设置为阿里镜像
    # npm config set registry https://registry.npmmirror.com
    # echo "npm版本："
    # npm --version

    # # 安装pnpm
    # sudo npm install -g pnpm
    # pnpm config set registry https://registry.npmmirror.com
    # echo "pnpm版本："
    # pnpm --version

    # # 安装yarn
    # sudo npm install -g yarn
    # yarn config set registry https://registry.npmmirror.com
    # echo "yarn版本："
    # pnpm --version
}

# 安装NVM
install_nvm() {
    echo "安装NVM..."

    # # 从GitHub安装nvm
    # curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    bash install ./nvm.sh

    # 加载nvm到当前shell
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

    # 验证nvm安装
    if command -v nvm &>/dev/null; then
        echo "NVM版本："
        nvm --version

        # 安装Node.js LTS版本
        nvm install --lts
        nvm use --lts

        nvm install 20
        nvm install 22
        nvm install 24

        echo "当前Node.js版本："
        node --version
    else
        echo "NVM安装失败，请手动安装"
    fi
}

# 安装Docker
install_docker() {
    echo "安装Docker..."

    # 移除旧版本
    sudo apt-get remove docker docker-engine docker.io containerd runc 2>/dev/null || true

    # 安装依赖
    sudo apt-get update -y
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    # 添加Docker官方GPG密钥
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # 设置repository
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    # 安装Docker
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # 验证安装
    sudo docker --version

    # 将当前用户添加到docker组
    if ! getent group docker | grep -q "\b$USER\b"; then
        sudo groupadd docker 2>/dev/null || true
        sudo usermod -aG docker $USER
        echo "已将用户 $USER 添加到docker组，请重新登录生效"
    fi

    echo "Docker安装完成！"
}

# 安装其他软件
install_other() {
    # TODO 可以安装你本地的应用
}

# 安装开发工具
install_development_tool() {
    echo "下载snap代理..."
    sudo snap install snap-store-proxy
    sudo snap install snap-store-proxy-client

    echo "安装开发工具..."

    sudo snap install intellij-idea --classic
    sudo snap install webstorm --classic
    sudo snap install datagrip --classic
}

# 执行其他函数
INSTALL_FUNCTIONS=(
    install_git
    install_java
    install_maven
    install_nodejs
    install_nvm
    install_docker
    install_other
    install_development_tool
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
