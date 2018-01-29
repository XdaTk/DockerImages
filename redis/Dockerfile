FROM registry.ops.heptagram.tech/devops/kubernetes/dockerimages/alpine:3.7

RUN apk add --no-cache redis \
    && rm -rf /tmp/* /var/cache/apk/*

ADD etc/redis.conf /etc/redis/redis.conf

USER root

WORKDIR /var/lib/redis

CMD ["redis-server", "/etc/redis/redis.conf"]

EXPOSE 6379
