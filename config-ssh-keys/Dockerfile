FROM fedora:24
ADD genkey.sh /
RUN dnf install -y openssh-clients openssl && \
    chmod +x /genkey.sh
CMD /genkey.sh
VOLUME /keys
