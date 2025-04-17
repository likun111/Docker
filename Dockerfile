FROM arm64v8/ubuntu:20.04

# 设置非交互环境
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y \
    ca-certificates
    
#换源为阿里云（ARM64专用）
RUN cat > /etc/apt/sources.list <<EOF
deb https://mirrors.aliyun.com/ubuntu-ports/ focal main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu-ports/ focal-security main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu-ports/ focal-updates main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu-ports/ focal-backports main restricted universe multiverse
EOF
# 安装基础软件依赖
RUN apt-get update && apt-get install -y \
    ca-certificates \
    sudo \
    wget \
    curl \
    gnupg2 \
    tzdata \
    python3 \
    python3-distro \
    python3-yaml \
    expect \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安装中文语言和字体，并设置时区
RUN apt-get update && \
    apt-get install -y language-pack-zh-hans* && \
    apt-get install -y locales && \
    apt-get install -y fonts-droid-fallback ttf-wqy-zenhei ttf-wqy-microhei fonts-arphic-ukai fonts-arphic-uming && \
    locale-gen zh_CN zh_CN.UTF-8 && \
    TZ="Asian/China" apt-get -y install tzdata && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

# 创建用户并配置sudo权限
RUN useradd -m -s /bin/bash -u 1000 user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 切换到用户环境安装ROS
USER user
WORKDIR /home/user

# 准备ROS安装配置文件
RUN echo "chooses:\n" > fish_install.yaml \
    && echo "- {choose: 1, desc: ''}\n" >> fish_install.yaml \
    && echo "- {choose: 2, desc: 不更换继续安装}\n" >> fish_install.yaml \
    && echo "- {choose: 2, desc: galactic(ROS2)}\n" >> fish_install.yaml \
    && echo "- {choose: 1, desc: galactic(ROS2)桌面版}\n" >> fish_install.yaml
# 下载并运行安装脚本（需要sudo权限）
RUN wget http://fishros.com/install -O fishros \
    && chmod +x fishros \
    && sudo /bin/bash fishros

# 清理工作
USER root
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# 设置默认用户和工作目录
USER user
WORKDIR /home/user
CMD ["/bin/bash"]
