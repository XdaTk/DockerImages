FROM alpine:3.7

MAINTAINER feng.qiang@zhongfl.com

ENV TIMEZONE=Asia/Shanghai \
    TZ=Asia/Shanghai \
    LANG=zh_CN.UTF-8

RUN echo "http://mirrors.aliyun.com/alpine/v3.7/main" > /etc/apk/repositories \
    && echo "http://mirrors.aliyun.com/alpine/v3.7/community" >> /etc/apk/repositories \
    && apk add --no-cache tzdata ca-certificates curl \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo $TIMEZONE > /etc/timezone \
    && rm -rf /tmp/* /var/cache/apk/*