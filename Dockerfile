FROM qnib/alplain-init:edge

ARG ETCD_VER=2.0.10
ENV ETCD_DATA_DIR=/data/ \
    HEALTHCHECK_DIR=/opt/healthchecks/
EXPOSE 2379 4001
VOLUME /data

RUN apk add --no-cache ca-certificates openssl tar \
 && wget -qO -  https://github.com/coreos/etcd/releases/download/v${ETCD_VER}/etcd-v${ETCD_VER}-linux-amd64.tar.gz |tar xfz - -C /bin/ --strip-components=1 \
 && apk --no-cache del --purge tar openssl
COPY opt/entry/*.env /opt/entry/
COPY opt/qnib/etcd/bin/start.sh /opt/qnib/etcd/bin/
COPY opt/healthchecks/10-etcd.sh /opt/healthchecks/
HEALTHCHECK --interval=3s --retries=15 --timeout=3s \
  CMD /usr/local/bin/healthcheck.sh
CMD ["/opt/qnib/etcd/bin/start.sh"]
