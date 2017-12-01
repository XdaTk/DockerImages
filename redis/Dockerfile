FROM centos:7.4.1708

RUN yum -y update && \
    yum -y install epel-release && \
	yum -y install redis && \
	yum clean all -q && \
    rm -fr /var/cache/yum/* /tmp/yum_save*.yumtx /root/.pki

ADD etc/redis.conf /etc/redis.conf

USER root

VOLUME ["/var/lib/redis"]

ENV HOME /var/lib/redis

WORKDIR /var/lib/redis

CMD ["/usr/bin/redis-server", "/etc/redis.conf"]

EXPOSE 6379
