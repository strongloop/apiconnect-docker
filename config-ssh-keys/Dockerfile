FROM centos
ADD genkey.sh /
RUN yum install -y openssh-clients openssl && \
    chmod +x /genkey.sh
CMD /genkey.sh
VOLUME /keys
