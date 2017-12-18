FROM registry.ops.heptagram.tech/devops/kubernetes/dockerimages/java/jre:8u151

MAINTAINER deng xufeng<deng.xufeng@zhongfl.com>

ENV KAFKA_VERSION=1.0.0
ENV SCALA_VERSION=2.12
ENV KAFKA_BIN_VERSION=$SCALA_VERSION-$KAFKA_VERSION
ENV KAFKA_HEAP_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=2"

RUN mkdir -p /opt/kafka \
    && curl -SLs "http://mirrors.ustc.edu.cn/apache/kafka/$KAFKA_VERSION/kafka_$KAFKA_BIN_VERSION.tgz" | tar -xzf - --strip-components=1 -C /opt/kafka \
    && rm -rf /opt/kafka/site-docs /opt/kafka/bin/windows

WORKDIR /opt/kafka