#!/bin/bash


ETCD_CMD="/bin/etcd -data-dir=${ETCD_DATA_DIR}/data -listen-peer-urls=${PEER_URLS} -listen-client-urls=${CLIENT_URLS} $*"
echo -e "Running '$ETCD_CMD'\nBEGIN ETCD OUTPUT\n"

exec $ETCD_CMD
