FROM registry.ops.heptagram.tech/devops/kubernetes/dockerimages/alpine:3.7

# 安装JDK
ENV JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=162 \
    JAVA_VERSION_BUILD=12 \
    JAVA_PACKAGE=server-jre \
    JAVA_JCE=unlimited \
    JAVA_HOME=/opt/jdk \
    PATH=${PATH}:/opt/jdk/bin \
    GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc \
    GLIBC_VERSION=2.26-r0 \
    DEFAULT_JVM_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=2 -XX:+UseG1GC"

RUN set -ex \
    && apk add --no-cache libstdc++ java-cacerts \
    && export http_proxy=http://192.168.3.100:1087 \
    && export https_proxy=http://192.168.3.100:1087 \
    && for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; do curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done \
    && apk add --allow-untrusted /tmp/*.apk \
    && rm -v /tmp/*.apk \
    && ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true )  \
    && echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh \
    && /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib \
    && mkdir /opt \
    && curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/java.tar.gz \
      http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/0da788060d494f5095bf8624735fa2f1/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz  \
    && JAVA_PACKAGE_SHA256=$(curl -sSL https://www.oracle.com/webfolder/s/digest/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}checksum.html | grep -E "${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64\.tar\.gz" | grep -Eo '(sha256: )[^<]+' | cut -d: -f2 | xargs)  \
    && echo "${JAVA_PACKAGE_SHA256}  /tmp/java.tar.gz" > /tmp/java.tar.gz.sha256 \
    && sha256sum -c /tmp/java.tar.gz.sha256 \
    && gunzip /tmp/java.tar.gz \
    && tar -C /opt -xf /tmp/java.tar \
    && ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/jdk \
    && if [ "${JAVA_JCE}" == "unlimited" ]; then echo "Installing Unlimited JCE policy" \
          && curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip \
            http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION_MAJOR}/jce_policy-${JAVA_VERSION_MAJOR}.zip  \
          && cd /tmp && unzip /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip  \
          && cp -v /tmp/UnlimitedJCEPolicyJDK8/*.jar /opt/jdk/jre/lib/security/; \
        fi \
    && sed -i s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=10/ $JAVA_HOME/jre/lib/security/java.security \
    && apk del glibc-i18n \
    && rm -rf /opt/jdk/*src.zip \
           /opt/jdk/lib/missioncontrol \
           /opt/jdk/lib/visualvm \
           /opt/jdk/lib/*javafx* \
           /opt/jdk/jre/plugin \
           /opt/jdk/jre/bin/javaws \
           /opt/jdk/jre/bin/jjs \
           /opt/jdk/jre/bin/orbd \
           /opt/jdk/jre/bin/pack200 \
           /opt/jdk/jre/bin/policytool \
           /opt/jdk/jre/bin/rmid \
           /opt/jdk/jre/bin/rmiregistry \
           /opt/jdk/jre/bin/servertool \
           /opt/jdk/jre/bin/tnameserv \
           /opt/jdk/jre/bin/unpack200 \
           /opt/jdk/jre/lib/javaws.jar \
           /opt/jdk/jre/lib/deploy* \
           /opt/jdk/jre/lib/desktop \
           /opt/jdk/jre/lib/*javafx* \
           /opt/jdk/jre/lib/*jfx* \
           /opt/jdk/jre/lib/amd64/libdecora_sse.so \
           /opt/jdk/jre/lib/amd64/libprism_*.so \
           /opt/jdk/jre/lib/amd64/libfxplugins.so \
           /opt/jdk/jre/lib/amd64/libglass.so \
           /opt/jdk/jre/lib/amd64/libgstreamer-lite.so \
           /opt/jdk/jre/lib/amd64/libjavafx*.so \
           /opt/jdk/jre/lib/amd64/libjfx*.so \
           /opt/jdk/jre/lib/ext/jfxrt.jar \
           /opt/jdk/jre/lib/ext/nashorn.jar \
           /opt/jdk/jre/lib/oblique-fonts \
           /opt/jdk/jre/lib/plugin.jar \
           /tmp/* /var/cache/apk/* \
    && ln -sf /etc/ssl/certs/java/cacerts $JAVA_HOME/jre/lib/security/cacerts \
    && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

# Maven
ARG MAVEN_VERSION=3.5.2
ENV MAVEN_HOME=/opt/maven
ENV MAVEN_CONFIG="/root/.m2"
ENV MAVEN_OPTS=${DEFAULT_JVM_OPTS}

RUN mkdir -p /opt/maven \
  && curl -fsSL -o /tmp/apache-maven.tar.gz "http://mirrors.ustc.edu.cn/apache/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" \
  && tar -xzf /tmp/apache-maven.tar.gz -C /opt/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /opt/maven/bin/mvn /usr/bin/mvn

# Node && Yarn
ARG NODE_VERSION=8.9.4
ARG YARN_VERSION=1.3.2
ENV NODE_REGIEST https://nexus.ops.heptagram.tech/repository/npm

RUN  apk add --no-cache libstdc++ \
    && apk add --no-cache --virtual .build-deps   binutils-gold g++ gcc libgcc linux-headers make python \
    && curl -SLO "https://npm.taobao.org/mirrors/node/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && apk del .build-deps \
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.xz" \
    && rm -rf /tmp/* /var/cache/apk/* \
    && npm config set registry $NODE_REGIEST

RUN apk add --no-cache --virtual .build-deps-yarn tar \
  && curl -fSLO --compressed "https://npm.taobao.org/mirrors/yarn/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && mkdir -p /opt/yarn \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/yarn --strip-components=1 \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
  && rm -rf yarn-v$YARN_VERSION.tar.gz \
  && apk del .build-deps-yarn \
  && rm -rf /tmp/* /var/cache/apk/* \
  && yarn config set registry $NODE_REGIEST

# Docker
ARG DOCKER_VERSION=17.03.2-ce
RUN apk add --no-cache --virtual .build-deps-docker tar \
  && curl -fL -o docker.tgz "http://mirrors.ustc.edu.cn/docker-ce/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" \
  && tar --extract --file docker.tgz --strip-components 1 --directory /usr/local/bin/ \
  && rm docker.tgz \
  && apk del .build-deps-docker \
  && rm -rf /tmp/* /var/cache/apk/*

# Kubernetes
ENV KUBERNETES_VERSION 1.8.2
ENV KUBECONFIG="/root/.kube/local"

RUN curl -LO "http://192.168.0.110/ops/images/app/kubectl" \
   && mv kubectl /usr/local/bin/ \
   && chmod +x /usr/local/bin/kubectl

# git
RUN apk add --no-cache git \
    && rm -rf /tmp/* /var/cache/apk/*