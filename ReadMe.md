# 初始化 KUbuntu Desktop 系统

> [!NOTE]
>
> 目前用的是 Ubuntu 的分支版本——KUbuntu25.10

根据您提供的文件内容，我将为您编写项目文档。

## 项目概述

这是一个 Ubuntu 系统初始化配置项目，主要包含 Maven 和 Ubuntu 系统的配置文件，用于优化开发环境。

## 目录结构

```
config/
├── settings.xml    # Maven配置文件
└── ubuntu.sources  # Ubuntu软件源配置文件
```

## 配置文件说明

> [!NOTE] 
>
> 两个文件分别是Maven文件、镜像文件

### 1. Maven 配置文件 ([settings.xml](file:///home/bunny/develop/Web/init-ubuntu/config/settings.xml))

这是 Apache Maven 的全局配置文件，用于配置本地仓库、镜像源和其他构建设置。

#### 主要配置项：

- **本地仓库路径**：

  ```xml
  <localRepository>~/.m2/repository</localRepository>
  ```

- **镜像源配置**：
  - 阿里云 Maven 镜像（替代中央仓库）
  ```xml
  <mirror>
    <id>alimaven</id>
    <name>Aliyun Maven</name>
    <url>https://maven.aliyun.com/repository/public</url>
    <mirrorOf>central</mirrorOf>
  </mirror>
  ```
  - 这个是Maven下载完成后就有的
  ```xml
  <mirror>
    <id>maven-default-http-blocker</id>
    <mirrorOf>external:http:*</mirrorOf>
    <name>Pseudo repository to mirror external repositories initially using HTTP.</name>
    <url>http://0.0.0.0/</url>
    <blocked>true</blocked>
  </mirror>
  ```

### 2. Ubuntu 软件源配置 (`ubuntu.sources`)

该文件配置了 Ubuntu 系统的软件包管理源，使用清华大学镜像站作为主要软件源。

#### 主要配置：

- **主软件源**：

  - 使用清华大学镜像站
  - 包含 `noble`, `noble-updates`, `noble-backports` 套件
  - 包含所有组件：`main`, `restricted`, `universe`, `multiverse`

- **安全更新源**：

  - 使用官方安全更新源
  - 包含 `noble-security` 套件
  - 包含所有组件：`main`, `restricted`, `universe`, `multiverse`

- **其他配置**：
  - 已注释源码镜像以提高更新速度
  - 预发布软件源默认禁用

## 默认执行内容

### stage_1_init

1. 将 [settings.xml](file:///home/bunny/develop/Web/init-ubuntu/config/settings.xml) 文件放置在 Maven 安装目录的 `conf` 文件夹中替换原配置文件，并且复制到用户目录下的 `.m2` 文件夹中。

2. 将 [ubuntu.sources](file:///home/bunny/develop/Web/init-ubuntu/config/ubuntu.sources) 文件放置在 `/etc/apt/sources.list.d/` 目录下，将原本的`/etc/apt/sources.list ` 文件复制为`/etc/apt/sources.list.backup`


### stage_2_system

1. 安装以下内容：curl、htop、zip unzip p7zip-full unrar tar gzip bzip2 xz-utils、stacer
2. 如果系统是Kubuntu或者是LinuxMint，*LibreOffice*是默认安装的，这里已经注释了
3. 安装VLC、Fcitx5、Wine

### stage_3_development

> [!IMPORTANT]
>
> 需要配置两个环境变量，奖项设置成你的IGit用户名和邮箱
>
> ```bash
> GIT_USERNAME
> GIT_EMAIL
> ```

会安装以下内容：Java、Maven、NodeJs、NIM、Docker

在函数`install_other`中可以添加别的安装内容里面没有写任何的内容

> [!WARNING]
>
> 如果不喜欢Snap的这里一定要注意下，安装的软件都是用Snap的 ！！！

会安装以下开发工具：snap-store-proxy、snap-store-proxy-client、intellij-idea 、webstorm、datagrip

### stage_4_customer

没有实现任何的内容

### stage_5_update

最后会进行更新，包含：软件和系统更新。

如果要配置Wine,需要手动进行配置，参考下面的命令：

```bash
# 先关闭所有 Wine 相关进程
wineserver -k

# 修改为 Windows 10
WINEPREFIX=~/.wine winecfg
# 在弹出的图形界面中：
# 1. 选择"Windows 10"
# 2. 应用 → 确定

# 或命令行修改
WINEPREFIX=~/.wine wine reg add \
  'HKCU\Software\Wine' \
  /v 'Version' \
  /d 'win10' \
  /f
```
