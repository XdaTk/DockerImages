FROM centos:centos7.4.1708

MAINTAINER feng.qiang@zhongfl.com

ENV TIMEZONE=Asia/Shanghai \
    TZ=Asia/Shanghai \
    LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    LANGUAGE=zh_CN.UTF-8:zh:en_US:en

RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo \
    && echo ZONE="Asia/Shanghai" > /etc/sysconfig/clock \
    && "cp" -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo export TIMEZONE=Asia/Shanghai >> /etc/profile \
    && echo export TZ=Asia/Shanghai >> /etc/profile \
    && yum install -y kde-l10n-Chinese \
    && yum reinstall -y glibc-common \
    && localedef -i zh_CN -f UTF-8 zh_CN.UTF-8 \
    && sed -i 's/LANG=.*/LANG="zh_CN.UTF-8"/g' /etc/locale.conf \
    && echo export LANG=zh_CN.UTF-8 >> /etc/profile \
    && echo export LC_ALL=zh_CN.UTF-8 >> /etc/profile \
    && echo export LANGUAGE=zh_CN.UTF-8:zh:en_US:en >> /etc/profile \
    && yum clean all -q \
    && rm -fr /var/cache/yum/* /tmp/yum_save*.yumtx /root/.pki