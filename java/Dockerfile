FROM registry.ops.heptagram.tech/devops/kubernetes/dockerimages/centos:7.4.1708

MAINTAINER feng.qiang@zhongfl.com

ARG JAVA_VERSION=8
ARG JAVA_UPD=151
ARG JAVA_BUILD=b12
ARG JED="${JAVA_VERSION}u${JAVA_UPD}"
ARG JRE="jdk1.${JAVA_VERSION}.0_${JAVA_UPD}"
ARG JAVA_HASH=e758a0de34e24606bca991d704f6dcbf

LABEL java.version="${JED}"

ENV DEFAULT_JVM_OPTS "-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=2 -XX:+UseG1GC"
ENV JAVA_HOME="/opt/${JRE}"


RUN yum install -y -q unzip \
    && export http_proxy=http://192.168.3.100:1087 \
    && export https_proxy=http://192.168.3.100:1087 \
    && curl -kL -H 'Cookie: oraclelicense=accept-securebackup-cookie' \
        "http://download.oracle.com/otn-pub/java/jdk/${JED}-${JAVA_BUILD}/${JAVA_HASH}/server-jre-${JED}-linux-x64.tar.gz" \
        | tar --no-same-owner -C /opt -zxf - \
    && curl -kL -o /tmp/jce_policy.zip -H 'Cookie: oraclelicense=accept-securebackup-cookie' \
        "http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip" \
    && unzip -q -d /tmp /tmp/jce_policy.zip \
    && rm -f /tmp/jce_policy.zip \
    && chmod -R 644 /tmp/UnlimitedJCEPolicyJDK8 \
    && mv /tmp/UnlimitedJCEPolicyJDK8/local_policy.jar "/opt/${JRE}/jre/lib/security/" \
    && mv /tmp/UnlimitedJCEPolicyJDK8/US_export_policy.jar "/opt/${JRE}/jre/lib/security/" \
    && rm -fr /tmp/UnlimitedJCEPolicyJDK8 \
    && rm -fr "/opt/${JRE}/man" "/opt/${JRE}/include" \
    && alternatives --install /usr/bin/java java "/opt/${JRE}/bin/java" 1 \
                    --slave /usr/bin/jar jar "/opt/${JRE}/bin/jar" \
    && yum remove -q -y unzip \
    && yum clean all -q \
    && rm -fr /var/cache/yum/* /tmp/yum_save*.yumtx /root/.pki