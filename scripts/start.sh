#!/bin/bash

# 开放宿主机的 X Server 权限
xhost +

docker start 0e6fc6af993e
docker exec -it 0e6fc6af993e bash
