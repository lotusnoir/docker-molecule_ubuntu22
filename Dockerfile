FROM ubuntu:22.04
LABEL maintainer="lotusnoir"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV container=docker
ENV DEBIAN_FRONTEND=noninteractive
STOPSIGNAL SIGRTMIN+3

RUN apt-get update && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends \
        ubuntu-keyring mlocate apt-utils vim locales systemd systemd-sysv sudo \
        python3-apt python3-pip iproute2 net-tools wget ca-certificates curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc /usr/share/man

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US:en

RUN python3 -m pip install --no-cache-dir --ignore-installed --upgrade pip \
    && python3 -m pip install --no-cache-dir ansible cryptography jmespath

# Pin goss version + verify checksum (update both when bumping version)
ENV GOSS_VERSION=0.4.9
ENV GOSS_SHA256="87dd36cfa1b8b50554e6e2ca29168272e26755b19ba5438341f7c66b36decc19"
RUN wget -q -O /usr/local/bin/goss \
        https://github.com/aelsabbahy/goss/releases/download/v${GOSS_VERSION}/goss-linux-amd64 \
    && echo "${GOSS_SHA256}  /usr/local/bin/goss" | sha256sum -c - \
    && chmod +x /usr/local/bin/goss

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
