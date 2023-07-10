Used for https://github.com/kth8/myblue
```shell
COPY --from=ghcr.io/kth8/kmod-zfs:${KERNEL_VERSION} /rpms /var/tmp
RUN rpm-ostree install /var/tmp/*.rpm
```
