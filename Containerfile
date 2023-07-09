ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} as builder
ARG KERNEL_VERSION="${KERNEL_VERSION}"
ARG ZFS_VERSION="${ZFS_VERSION}"

RUN rpm-ostree install -y dkms gcc make autoconf automake libtool rpm-build libtirpc-devel libblkid-devel \
	libuuid-devel libudev-devel openssl-devel zlib-devel libaio-devel libattr-devel elfutils-libelf-devel \
	kernel-modules-${KERNEL_VERSION} kernel-devel-${KERNEL_VERSION} python3-devel python3-setuptools \
	python3-cffi libffi-devel ncompress libcurl-devel

RUN ln -s /usr/bin/ld.bfd /etc/alternatives/ld && ln -s /etc/alternatives/ld /usr/bin/ld
RUN curl -L https://github.com/openzfs/zfs/releases/download/${ZFS_VERSION}/${ZFS_VERSION}.tar.gz -o /tmp/${ZFS_VERSION}.tar.gz
RUN tar -xzf /tmp/${ZFS_VERSION}.tar.gz -C /tmp

WORKDIR /tmp/${ZFS_VERSION}
RUN ./configure -with-linux=/usr/src/kernels/${KERNEL_VERSION} -with-linux-obj=/usr/src/kernels/${KERNEL_VERSION}
RUN make -j rpm-utils rpm-kmod
RUN rm -fv *src.rpm *devel*.rpm *debug*.rpm *test*.rpm *dracut*.rpm
RUN mv -v *.rpm /var/tmp/

FROM scratch
COPY --from=builder /var/tmp /rpms
