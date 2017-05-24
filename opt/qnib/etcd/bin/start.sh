#!/bin/bash

ETCD_OPTS="--name $(hostname) --initial-cluster-token ${ETCD_CLUSTER_TOKEN} --initial-advertise-peer-urls http://${MY_IP}:2380"
ETCD_OPTS="${ETCD_OPTS} -data-dir=${ETCD_DATA_DIR} -listen-peer-urls=${PEER_URLS} -listen-client-urls=${CLIENT_URLS} $*"
echo -e "Running '/bin/etcd $ETCD_OPTS'\nBEGIN ETCD OUTPUT\n"

exec /bin/etcd $ETCD_OPTS
