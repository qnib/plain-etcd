FROM qnib/uplain-init

ARG ETCD_VER=3.3.0-rc.0
ENV ETCD_DATA_DIR=/data/ \
    HEALTHCHECK_DIR=/opt/healthchecks/ \
    FISHERMAN_FORMAT="etcd" \
    FISHERMAN_OUT="list"
EXPOSE 2379 4001
VOLUME /data

RUN apt-get update
RUN apt-get install -y ca-certificates openssl curl wget \
 && wget -qO - https://github.com/coreos/etcd/releases/download/v${ETCD_VER}/etcd-v${ETCD_VER}-linux-amd64.tar.gz |tar xfz - -C /bin/ --strip-components=1
COPY opt/entry/*.env opt/entry/*.sh /opt/entry/
COPY opt/qnib/etcd/bin/start.sh /opt/qnib/etcd/bin/
COPY opt/healthchecks/10-etcd.sh /opt/healthchecks/
HEALTHCHECK --interval=3s --retries=45 --timeout=3s \
  CMD /usr/local/bin/healthcheck.sh
CMD ["/opt/qnib/etcd/bin/start.sh"]
