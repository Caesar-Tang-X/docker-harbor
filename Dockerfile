FROM centos/systemd

# harbor version
ENV HARBOR_VERSION 1.5.1
ENV HARBOR_HOSTNAME 192.168.101.16
ENV HARBOR_ADMIN_PASSWORD admin
ENV HARBOR_SELF_REGISTERATION off
# run port
ENV APP_PORT 80

# install libs
RUN yum -y install yum-utils which curl wget openssl openssl-devel epel-release
RUN yum makecache fast

# install docker-ce
RUN yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
RUN yum -y install docker-ce
RUN systemctl enable docker

# install docker-compose
RUN curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.0/docker-compose-`uname -s`-`uname -m` --user-agent "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36" > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
RUN docker-compose --version

# download harbor
RUN wget --no-check-certificate https://storage.googleapis.com/harbor-releases/release-1.5.0/harbor-offline-installer-v${HARBOR_VERSION}.tgz -O harbor-offline-installer-v${HARBOR_VERSION}.tgz --user-agent="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36" \
    && tar xvf harbor-offline-installer-v${HARBOR_VERSION}.tgz \
    && ( \
    cd harbor \
    && sed -i "s/hostname = reg.mydomain.com/hostname = ${HARBOR_HOSTNAME}/g" harbor.cfg \
    && sed -i "s/harbor_admin_password = Harbor12345/harbor_admin_password = ${HARBOR_ADMIN_PASSWORD}/g" harbor.cfg \
    && sed -i "s/self_registration = on/self_registration = ${HARBOR_SELF_REGISTERATION}/g" harbor.cfg \
    )
# nake harbor run with boot
COPY ./entrypoint.sh /etc/rc.d/init.d/entrypoint.sh 
RUN chmod +x /etc/rc.d/init.d/entrypoint.sh && chkconfig --add entrypoint.sh && chkconfig entrypoint.sh on

# clean all
RUN rm -f harbor-offline-installer-v${HARBOR_VERSION}.tgz
RUN yum clean all

# expose port
EXPOSE ${APP_PORT}

# start server
ENTRYPOINT ["/usr/sbin/init"]