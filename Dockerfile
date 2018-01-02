FROM qnib/alplain-init

ARG ETCD_VER=3.3.0-rc.0
ENV ETCD_DATA_DIR=/data/ \
    HEALTHCHECK_DIR=/opt/healthchecks/ \
    FISHERMAN_FORMAT="etcd" \
    FISHERMAN_OUT="list"
EXPOSE 2379 4001
VOLUME /data

RUN apk add --no-cache ca-certificates openssl curl tar \
 && wget -qO - https://github.com/coreos/etcd/releases/download/v${ETCD_VER}/etcd-v${ETCD_VER}-linux-amd64.tar.gz |tar xfz - -C /bin/ --strip-components=1 \
 && wget -qO - https://github.com/sequenceiq/docker-alpine-dig/releases/download/v9.10.2/dig.tgz |tar -xzv -C /usr/local/bin/ \
 && apk --no-cache del --purge tar openssl curl

COPY opt/entry/*.env opt/entry/*.sh /opt/entry/
COPY opt/qnib/etcd/bin/start.sh /opt/qnib/etcd/bin/
COPY opt/healthchecks/10-etcd.sh /opt/healthchecks/
HEALTHCHECK --interval=3s --retries=45 --timeout=3s \
  CMD /usr/local/bin/healthcheck.sh
CMD ["/opt/qnib/etcd/bin/start.sh"]
RUN echo 'etcdctl --endpoints "http://$(go-fisherman etcd_peer):2379" member list' >> /root/.bash_history
