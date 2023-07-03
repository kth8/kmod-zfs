ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/base"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} as builder

COPY zfs.sh /tmp/zfs.sh
RUN chmod +x /tmp/zfs.sh && /tmp/zfs.sh

FROM scratch

COPY --from=builder /var/tmp /rpms
