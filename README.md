# Harbor 1.5.1


## 镜像简介
    1. Harbor 是由VMware公司开源的企业级的Docker Registry管理项目，它包括权限管理(RBAC)、LDAP、日志审核、管理界面、自我注册、镜像复制和中文支持等功能。
    2. 通过该镜像创建容器后启动或重启, 会自动重载 Harbor 配置文件, 并启动服务。启动服务 ( Harbor 服务的容器创建和运行 ) 需要点时间, 请耐心等待。


## 镜像环境：
	centos：centos/systemd: 7
	harbor：1.5.1


## dockerfile 构建镜像：
	1. 从 github 下载 Dockerfile 文件：https://github.com/Caesar-Tang-X/docker-harbor.git
    2. 修改 Harbor 基本配置：vi Dockerfile
        HARBOR_HOSTNAME：Harbor服务启动后的 hostname, 务必改为您自己的主机ip
        HARBOR_ADMIN_PASSWORD：Harbor服务启动后的 admin 账号的密码
        HARBOR_SELF_REGISTERATION：是否开启Harbor服务的用户自注册功能 (on：开启 off：关闭)
	3. 运行：
        docker build --rm -t caesartang/harbor:1.5.1 .


## dockerhub 下载镜像：
	1. dockerhub：https://hub.docker.com/repository/docker/caesartang/harbor
	2. 下载镜像：
        docker pull caesartang/harbor:1.5.1



## docker 运行命令：
	1. 运行：
		docker run -itd --privileged=true --name harbor -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 80:80 caesartang/harbor:1.5.1
	参数说明：
		--privileged：使用户具备 root 权限 (必须)
		-v /sys/fs/cgroup:/sys/fs/cgroup:ro：使服务可使用 systemctl (必须)
		-p 80:80：服务监听端口
	注：运行前请打开服务器对应端口；采用上述命令运行后，产生的数据及日志文件都在容器内，若需容器和宿主机打通，可按需调整命令
	docker命令大全：https://docs.docker.com/engine/reference/commandline/run/
	2. 进入容器：
		docker exec -it harbor /bin/bash
    3. 查询服务是否启动：
	    cat /harbor/run.log 
       或
        ps -ef|grep harbor|grep install
    4. 查询服务是否启动完成 (当所有容器状态为 Up 且有健康检查的健康状态为 healthy 时，表示启动完成)：
        docker ps -a
    5. 访问服务：
        http://hostname
 


##  安装及生成数据路径：
	|--- /harbor             	  // Harbor 文件
		|--- LICENSE             
        |--- NOTICE                        
        |--- common                        
        |--- docker-compose.clair.yml      // docker-compose 配置文件
        |--- docker-compose.notary.yml     // docker-compose 配置文件
        |--- docker-compose.yml            // docker-compose 配置文件
        |--- ha                            
        |--- harbor.cfg                    // 配置文件
        |--- harbor.v1.5.1.tar.gz          // 离线安装包 
		|--- install.sh                    // 安装脚本
        |--- prepare                       // 预处理配置
        |--- run.log                       // 启动或重启记录
	|--- /data             	      // Harbor 数据文件


##  可能遇到的问题：
    1. 各服务间通信超时问题：
    ERROR: An HTTP request took too long to complete. Retry with --verbose to obtain debug information.
           If you encounter this issue regularly because of slow network conditions, consider setting COMPOSE_HTTP_TIMEOUT to a higher value (current value: 60).
    解决方案：
    (1) 进入容器：
        docker exec -it harbor /bin/bash
    (2) 在尾部添加代码：
        export COMPOSE_HTTP_TIMEOUT=500
        export DOCKER_CLIENT_TIMEOUT=500
    (3) 使/etc/profile配置文件生效：
        source /etc/profile
    (4) 重新安装
        ./harbor/install.sh
