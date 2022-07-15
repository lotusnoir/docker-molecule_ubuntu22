FROM ubuntu:22.04
LABEL maintainer="lotusnoir"

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends systemd systemd-sysv sudo python3-apt python3-pip iproute2 net-tools wget ca-certificates \
    && python3 -m pip install --no-cache-dir --upgrade pip \
    && python3 -m pip install --no-cache-dir ansible cryptography jmespath \
    && apt-get clean \
    && wget -q -O /usr/local/bin/goss https://github.com/aelsabbahy/goss/releases/download/v0.3.18/goss-linux-amd64 \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc /usr/share/man \
    && rm -f /lib/systemd/system/multi-user.target.wants/* \
    /lib/systemd/system/systemd*udev* \
    /lib/systemd/system/getty.target \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    /lib/systemd/system/systemd-update-utmp*

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
ENTRYPOINT ["/lib/systemd/systemd"]
