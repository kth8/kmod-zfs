```shell
COPY --from=ghcr.io/kth8/kmod-zfs:latest /rpms /var/tmp
RUN rpm-ostree install /var/tmp/*.rpm
```
