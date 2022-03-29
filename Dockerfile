FROM debian:buster

LABEL repository="https://github.com/debian-cryptoanarchy/cryptoanarchy-deb-repo-builder"

ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update && apt-get dist-upgrade && \
    apt-get install apt-utils && \
    apt-get install wget cargo npm git apt-transport-https \
    ruby-mustache dirmngr sudo libvips-dev ca-certificates gpg \
    systemd systemd-sysv net-tools netcat xxd && \
    update-ca-certificates && \
    wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    cargo install --git https://github.com/Kixunil/debcrafter && \
    cargo install cfg_me && \
    mkdir -p /tmp/tmpcargobin && cp /root/.cargo/bin/* /tmp/tmpcargobin && \
    rm -rf /root/.cargo/* && mv /tmp/tmpcargobin /root/.cargo/bin && \
    apt-get autoremove && apt-get clean && \
    rm -rf packages-microsoft-prod.deb /root/.cargo/bin/cargo-cache \
    /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    /lib/systemd/system/systemd-update-utmp* \
    /usr/sbin/policy-rc.d

ENV PATH="/root/.cargo/bin:${PATH}"

RUN mkdir -p /root/.gnupg/private-keys-v1.d && \
    chmod 700 /root/.gnupg/private-keys-v1.d

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/lib/systemd/systemd"]
