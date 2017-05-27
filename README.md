# plain-etcd
Image holding etcd.

## Testdrive

To spin up a etcd cluster consisting of three nodes, just start the docker-compose file.

```bash
$  docker stack deploy -c docker-compose.yml etcd
Creating service etcd_peer
```

It will use `go-fisherman` to query the embedded DNS server to discover the other etcd tasks.

```bash
$ docker exec -ti $(docker ps -qlf label=com.docker.swarm.service.name=etcd_peer) go-fisherman --template=etcd -o bash etcd_peer |xargs -n1
etcd_peer.1.dczmod9t5z7mrkq18xb4tou8v=http://10.0.3.3:2380
etcd_peer.2.dzzka6xqia76lioekc39ijo1i=http://10.0.3.4:2380
etcd_peer.3.jgtze0ps0fff6fo1goor1xcgv=http://10.0.3.5:2380
```
After a bit, the cluster should be open for business.

```bash
$ etcdctl member list
4e6817b238bae8c2: name=etcd_peer.2.dzzka6xqia76lioekc39ijo1i peerURLs=http://10.0.3.4:2380 clientURLs=http://localhost:2379,http://localhost:4001 isLeader=true
86a9baf1973d07fa: name=etcd_peer.1.dczmod9t5z7mrkq18xb4tou8v peerURLs=http://10.0.3.3:2380 clientURLs=http://localhost:2379,http://localhost:4001 isLeader=false
d8778926644f3a3e: name=etcd_peer.3.jgtze0ps0fff6fo1goor1xcgv peerURLs=http://10.0.3.5:2380 clientURLs=http://localhost:2379,http://localhost:4001 isLeader=false
```

Setting a key on one of the nodes, makes it available on all.

```bash
$ etcdctl set key1 $(date +%s)
1495885955
$ for x in $(docker ps -q); do echo "### $x" ; docker exec -t $x etcdctl get key1;done
### a04fabd24d01
1495885955
### 487fa632cbcd
1495885955
### 6d8a8cd4bbe7
1495885955
```