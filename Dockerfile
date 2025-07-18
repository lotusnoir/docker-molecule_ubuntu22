FROM ubuntu:22.04
LABEL maintainer="lotusnoir"

ENV container=docker
ENV DEBIAN_FRONTEND=noninteractive
STOPSIGNAL SIGRTMIN+3

RUN apt-get update && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends ubuntu-keyring mlocate apt-utils vim locales systemd systemd-sysv sudo python3-apt python3-pip iproute2 net-tools wget ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc /usr/share/man \
    && apt-get clean

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

RUN python3 -m pip install --no-cache-dir --upgrade pip \
    && python3 -m pip install --no-cache-dir ansible cryptography jmespath

RUN wget -q -O /usr/local/bin/goss https://github.com/aelsabbahy/goss/releases/download/v0.4.9/goss-linux-amd64 && chmod +x /usr/local/bin/goss

RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /lib/systemd/system/systemd*udev* \
    /lib/systemd/system/getty.target \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    /lib/systemd/system/systemd-update-utmp*

VOLUME [ "/tmp", "/run", "/run/lock" ]
ENTRYPOINT ["/lib/systemd/systemd", "log-level=info", "unit=sysinit.target"]
