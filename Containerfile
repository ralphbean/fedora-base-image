FROM registry.fedoraproject.org/fedora:40 as builder

RUN mkdir -p /mnt/rootfs

RUN \
    dnf install --installroot /mnt/rootfs \
        bash \
        coreutils-single \
        coreutils-single \
        crypto-policies-scripts \
        findutils \
        gdb-gdbserver \
        glibc-minimal-langpack \
        glibc-minimal-langpack \
        gzip \
        langpacks-en \
        fedora-release \
        rootfiles \
        tar \
        vim-minimal \
        dnf \
        --releasever "40" --setopt install_weak_deps=false --nodocs -y; \
    dnf --installroot /mnt/rootfs clean all

RUN ls -alh /mnt/rootfs/usr
RUN ls -alh /mnt/rootfs/usr/bin
RUN mkdir /mnt/rootfs/bin && cp /mnt/rootfs/usr/bin/sh /mnt/rootfs/bin/sh
RUN rm -rf /mnt/rootfs/var/cache/* /mnt/rootfs/var/log/dnf* /mnt/rootfs/var/log/yum.*

FROM scratch

LABEL license="MIT",
LABEL name="fedora",
LABEL org.opencontainers.image.license="MIT",
LABEL org.opencontainers.image.name="fedora",
LABEL org.opencontainers.image.url="https://fedoraproject.org/",
LABEL org.opencontainers.image.vendor="Fedora Project",
LABEL org.opencontainers.image.version="40",
LABEL vendor="Fedora Project",
LABEL version="40"

COPY --from=builder /mnt/rootfs/ /
RUN rm -rf /etc/yum.repos.d/*.repo
COPY --from=builder /etc/yum.repos.d/*.repo /etc/yum.repos.d/.
CMD /bin/bash
