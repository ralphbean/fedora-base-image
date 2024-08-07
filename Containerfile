FROM registry.fedoraproject.org/fedora:41 as builder

RUN mkdir -p /mnt/rootfs

RUN sed -i 's|gpgcheck|gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch\ngpgcheck|g' /etc/yum.repos.d/cachi2.repo || true

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
        --releasever "40" --setopt install_weak_deps=false --nodocs -y && \
    dnf --installroot /mnt/rootfs clean all

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
