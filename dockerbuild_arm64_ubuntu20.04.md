#安装docker
#换docker拉取镜像的源
#拉取镜像
docker pull arm64v8/ubuntu:20.04
#安装binfmt-support
sudo apt update
sudo apt install binfmt-support qemu-user-static
#注册 QEMU 模拟器
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
#4启动容器
docker run --platform linux/arm64 -it arm64v8/ubuntu:20.04 /bin/bash
#先安装ca-certificates及换源
apt get ca-certificates
cat > /etc/apt/sources.list <<EOF
deb https://mirrors.aliyun.com/ubuntu-ports/ focal main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu-ports/ focal-security main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu-ports/ focal-updates main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu-ports/ focal-backports main restricted universe multiverse
EOF
#新建普通用户
useradd -m -s <用户名>
passwd <用户名>
#容器没有sudo，先安装
apt install -y sudo
#赋予普通用户执行权限
usermod -aG sudo <用户名>
#切换到普通用户
sudo -iu <用户名>
#下载ros2 小鱼儿一键安装
wget http://fishros.com/install -O fishros && . fishros
#下载自动补全工具
sudo apt update
sudo apt install -y bash-completion
#后续自行添加
#docker保存自己的镜像
1.docker commit指令
docker commit [选项] <容器ID或名称> <新镜像名>:<标签>
ps:docker commit 63a7ea37e358 arm64_ubuntu20.04:v2
2.Dokerfile文件构建方法
https://blog.csdn.net/wlddhj/article/details/135393280
#鱼香脚本在Dockerfile里安装ros2
https://github.com/fishros/install
