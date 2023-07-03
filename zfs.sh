#!/bin/sh
set -oeux pipefail
KERNEL_VERSION="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
ZFS_VERSION="$(curl -s https://api.github.com/repos/openzfs/zfs/releases/latest | jq -r .tag_name)"

rpm-ostree install -y dkms gcc make autoconf automake libtool rpm-build libtirpc-devel libblkid-devel \
    libuuid-devel libudev-devel openssl-devel zlib-devel libaio-devel libattr-devel elfutils-libelf-devel \
    kernel-modules-${KERNEL_VERSION} kernel-devel-${KERNEL_VERSION} python3-devel python3-setuptools \
    python3-cffi libffi-devel ncompress libcurl-devel

curl -L https://github.com/openzfs/zfs/releases/download/${ZFS_VERSION}/${ZFS_VERSION}.tar.gz | tar -xzC /tmp

cd /tmp/${ZFS_VERSION}

ln -s /usr/bin/ld.bfd /etc/alternatives/ld && ln -s /etc/alternatives/ld /usr/bin/ld
./configure -with-linux=/usr/src/kernels/${KERNEL_VERSION}/ -with-linux-obj=/usr/src/kernels/${KERNEL_VERSION}/ && \
	make -j rpm-utils rpm-kmod || \
	(cat config.log && exit 1)

rm -fv *src.rpm *devel*.rpm *debug*.rpm *test*.rpm zfs-dracut*.rpm
mv -v *.rpm /var/tmp/
