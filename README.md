```shell
COPY --from=ghcr.io/kth8/akmod-zfs:latest /rpms /var/tmp
RUN rpm-ostree install /var/tmp/*.rpm
```
