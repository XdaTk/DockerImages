FROM registry.ops.heptagram.tech/devops/kubernetes/dockerimages/centos:7.4.1708

# 安装JDK
ARG JAVA_VERSION=8
ARG JAVA_UPD=151
ARG JAVA_BUILD=b12
ARG JED=${JAVA_VERSION}u${JAVA_UPD}
ARG JDK=jdk1.${JAVA_VERSION}.0_${JAVA_UPD}
ARG JAVA_HASH=e758a0de34e24606bca991d704f6dcbf

LABEL java.version="${JED}"

ENV JAVA_HOME=/opt/${JDK}
ENV DEFAULT_JVM_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=2 -XX:+UseG1GC"

RUN yum install -y unzip \
 && export http_proxy=http://192.168.3.100:1087 \
 && export https_proxy=http://192.168.3.100:1087 \
 && curl -kL -H 'Cookie: oraclelicense=accept-securebackup-cookie' \
    "http://download.oracle.com/otn-pub/java/jdk/${JED}-${JAVA_BUILD}/${JAVA_HASH}/jdk-${JED}-linux-x64.tar.gz" \
    | tar -C /opt -zxf - \
 && curl -kL -o /tmp/jce_policy.zip -H 'Cookie: oraclelicense=accept-securebackup-cookie' \
    "http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip" \
 && unzip -d /tmp /tmp/jce_policy.zip \
 && rm -f /tmp/jce_policy.zip \
 && chmod 644 -R /tmp/UnlimitedJCEPolicyJDK8 \
 && mv /tmp/UnlimitedJCEPolicyJDK8/local_policy.jar /opt/${JDK}/jre/lib/security/ \
 && mv /tmp/UnlimitedJCEPolicyJDK8/US_export_policy.jar /opt/${JDK}/jre/lib/security/ \
 && rm -fr /tmp/UnlimitedJCEPolicyJDK8 \
 && chown -R root: /opt/${JDK} \
 && alternatives --install /usr/bin/java java /opt/${JDK}/bin/java 1 \
 && alternatives --install /usr/bin/javac javac /opt/${JDK}/bin/javac 1 \
 && alternatives --install /usr/bin/jar jar /opt/${JDK}/bin/jar 1 \
 && yum remove -y unzip \
 && yum clean all \
 && rm -fr /var/cache/yum/* /tmp/yum_save*.yumtx /root/.pki

# Maven
ARG MAVEN_VERSION=3.5.2
LABEL maven.version="${MAVEN_VERSION}"
ENV MAVEN_HOME=/opt/maven
ENV MAVEN_CONFIG="/root/.m2"
ENV MAVEN_OPTS=${DEFAULT_JVM_OPTS}

RUN mkdir -p /opt/maven \
  && curl -fsSL -o /tmp/apache-maven.tar.gz "http://mirrors.ustc.edu.cn/apache/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" \
  && tar -xzf /tmp/apache-maven.tar.gz -C /opt/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /opt/maven/bin/mvn /usr/bin/mvn

# Node
ARG NODE_VERSION=8.9.1
ARG YARN_VERSION=1.3.2
ENV SASS_BINARY_SITE https://npm.taobao.org/mirrors/node-sass/
ENV NODE_REGIEST https://nexus.ops.heptagram.tech/repository/npm

RUN curl -SLO "https://npm.taobao.org/mirrors/node/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

RUN curl -fSLO --compressed "https://npm.taobao.org/mirrors/yarn/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && mkdir -p /opt/yarn \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/yarn --strip-components=1 \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz \
  && npm config set registry $NODE_REGIEST \
  && yarn config set registry $NODE_REGIEST

# Docker
ARG DOCKER_VERSION=17.03.2-ce
RUN curl -fL -o docker.tgz "http://mirrors.ustc.edu.cn/docker-ce/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" \
  && tar --extract --file docker.tgz --strip-components 1 --directory /usr/local/bin/ \
  && rm docker.tgz

# Kubernetes
ENV KUBERNETES_VERSION 1.8.2
ENV KUBECONFIG="/root/.kube/local"

RUN curl -LO "http://192.168.0.110/ops/images/kube/$KUBERNETES_VERSION/kubectl" \
   && mv kubectl /usr/local/bin/ \
   && chmod +x /usr/local/bin/kubectl