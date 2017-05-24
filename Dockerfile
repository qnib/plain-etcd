FROM qnib/alplain-init:edge
ARG ETCD_VER=2.0.10
RUN apk add --no-cache ca-certificates openssl tar \
 && wget -qO -  https://github.com/coreos/etcd/releases/download/v${ETCD_VER}/etcd-v${ETCD_VER}-linux-amd64.tar.gz |tar xfz - -C /bin/ --strip-components=1 \
 && apk --no-cache del --purge tar openssl
VOLUME /data
COPY opt/entry/*.env /opt/entry/
COPY opt/qnib/etcd/bin/start.sh /opt/qnib/etcd/bin/
COPY opt/healthcheck/10-etcd.sh /opt/healthcheck/
EXPOSE 2379 4001
ENV ETCD_DATA_DIR=/data/
HEALTHCHECK --interval=3s --retries=15 --timeout=3s \
  CMD /usr/local/bin/healthcheck.sh
CMD ["/opt/qnib/etcd/bin/start.sh"]
