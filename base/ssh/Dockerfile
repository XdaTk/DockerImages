FROM registry.ops.heptagram.tech/devops/kubernetes/dockerimages/centos:7.4.1708

ADD init.sh /opt/init.sh
ADD supervisord.conf /opt/supervisord.conf

RUN yum -y install epel-release \
    && yum -y install supervisor vim curl git openssh-server openssh-clients strace \
    && ssh-keygen -q -b 1024 -N '' -t rsa -f /etc/ssh/ssh_host_rsa_key \
    && ssh-keygen -q -b 1024 -N '' -t dsa -f /etc/ssh/ssh_host_dsa_key \
    && ssh-keygen -q -b 521 -N '' -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key \
    && ssh-keygen -q -b 1024 -N '' -t ed25519 -f /etc/ssh/ssh_host_ed25519_key \
    && sed -i -r 's/.?UseDNS\syes/UseDNS no/' /etc/ssh/sshd_config \
    && sed -i -r 's/.?ChallengeResponseAuthentication.+/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config \
    && sed -i -r 's/.?PermitRootLogin.+/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && echo "root:bbt" | chpasswd \
    && yum clean all && rm -rf /tmp/yum*

CMD ["/opt/init.sh"]