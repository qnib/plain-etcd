#!/bin/bash
echo -e "Running '/bin/etcd $ETCD_OPTS'\nBEGIN ETCD OUTPUT\n"
exec /bin/etcd ${ETCD_OPTS}
