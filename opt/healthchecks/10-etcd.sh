#!/bin/bash
set -e

etcdctl --endpoints=http://$(go-fisherman --print-container-ip):2379 member list
