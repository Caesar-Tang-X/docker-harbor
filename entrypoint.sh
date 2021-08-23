#!/bin/bash
# chkconfig:   2345 90 10
# description:  harbor

# 设置时区
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# 获取当前时间, 并记录日志
time=$(date "+%Y-%m-%d %H:%M:%S")
echo -e "${time} : run install \n" >> harbor/run.log
# 安装或重启 harbor 服务
./harbor/prepare
./harbor/install.sh

