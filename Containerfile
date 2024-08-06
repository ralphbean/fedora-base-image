ARG version
FROM registry.fedoraproject.org/fedora:$version as builder

ARG version
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
        yum \
        --releasever "$version" --setopt install_weak_deps=false --nodocs -y; \
    dnf --installroot /mnt/rootfs clean all

RUN rm -rf /mnt/rootfs/var/cache/* /mnt/rootfs/var/log/dnf* /mnt/rootfs/var/log/yum.*

FROM scratch

ARG version
LABEL license="MIT",
LABEL name="fedora",
LABEL org.opencontainers.image.license="MIT",
LABEL org.opencontainers.image.name="fedora",
LABEL org.opencontainers.image.url="https://fedoraproject.org/",
LABEL org.opencontainers.image.vendor="Fedora Project",
LABEL org.opencontainers.image.version="$version",
LABEL vendor="Fedora Project",
LABEL version="$version"

COPY --from=builder /mnt/rootfs/ /
RUN rm -rf /etc/yum.repos.d/*.repo
COPY --from=builder /etc/yum.repos.d/*.repo /etc/yum.repos.d/.
CMD /bin/bash
