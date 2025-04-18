#!/bin/bash

# 开放宿主机的 X Server 权限
xhost +

# 创建并启动容器
docker run -itd \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY \
    --name x11-docker \
    my_x86_ubuntu20.4:v1 bash -c "apt update && apt install -y x11-apps && bash"

# 在运行的容器中执行 xclock
docker exec -it x11-docker bash -c "xclock"

# 恢复 X Server 权限
xhost -
