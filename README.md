# Mission
1. Fast setup multi redis cluster in multi nodes.
2. Fast setup all-in-one redis cluster in one node.

# Build

```docker build -t redis-cluster-docker .```

# Usage

### Use case - Deploy cluster in multi nodes:

Step 1.
Edit {FROM_PORT} and {TO_PORT} parameter for none used ports.

On every node:

```docker run --restart=always --name {NAME}_{FROM_PORT}-{TO_PORT} --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p {FROM_PORT}-{TO_PORT}:6379-6380 -e PORT_SEQ="{FROM_PORT} {TO_PORT}" --network=host -d -t redis-cluster-docker```

or

```docker-compose -f docker-compose.yml up -d```

Example:

```
version: '2'
services:
  redis:
    image: redis-cluster-docker
    container_name: test_7000-7001
    restart: always
    privileged: true
    network_mode: "host"
    ports:
      - "7000-7001:6379-6380"
    environment:
      PORT_SEQ: "7000 7001"
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro

```

Step 2.
On one of node:
Setup redis cluster.

```docker exec -t test_7000-7001 /bin/bash -c "echo "yes" | redis-trib.rb create --replicas 1 {HOST_IP1}:7000 {HOST_IP2}:7000 {HOST_IP3}:7000 {HOST_IP1}:7001 {HOST_IP2}:7001 {HOST_IP3}:7001"```

> **WARNNING:**
> If youy want to create redis cluster in multi node, Run Step 2. **AFTER** slave node ready.

### Use case - Deploy all in one cluster:

```
On one node:
$ docker run --restart=always --name {NAME}_6379-6384 --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 6379-6384:6379-6384 -e PORT_SEQ="6379 6384" -e HOSTS_IP=192.168.1.1 --network=host -d -t redis-cluster-docker
```

or

```docker-compose -f docker-compose.yml up -d```

Example:

```
version: '2'
services:
  redis:
    image: redis-cluster-docker
    container_name: test_6379-6384
    restart: always
    privileged: true
    network_mode: "host"
    ports:
      - "6379-6384:6379-6380"
    environment:
      HOSTS_IP: "192.168.1.1"
      PORT_SEQ: "6379 6384"
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro

```

### Verify redis cluster:

```
Check:
$ docker exec -it {NAME} /bin/bash -c "/usr/local/sbin/redis-trib.rb check {NODE_IP}:{REDIS_PORT}"
```

# REF
nog[docker-redis-cluster](http://kuga.me/2016/07/22/docker-redis-cluster/)
