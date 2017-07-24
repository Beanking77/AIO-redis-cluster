#!/bin/sh

CLUSTER_STR=""

if [ "$PORT_SEQ" != "" ]; then
    for port in `seq $PORT_SEQ`; do
      mkdir -p /redis-conf/${port}
      mkdir -p /redis-data/${port}
      mkdir /etc/redis 
      mkdir -p /var/lib/redis/${port}/ 

      if [ -e /redis-data/${port}/nodes.conf ]; then
        rm /redis-data/${port}/nodes.conf
      fi
      PORT=${port} envsubst < /redis-conf/redis-cluster.tmpl > /redis-conf/${port}/redis.conf
      redis-server /redis-conf/${port}/redis.conf
    done
else
  exec "$@"
fi

if [ "$HOSTS_IP" != "" ];then
  for port in `seq $PORT_SEQ`; do
    for NODE_IP in $HOSTS_IP; do
      CLUSTER_STR+="${NODE_IP}:${port} "
    done
  done
  echo "yes" | redis-trib.rb create --replicas 1 $CLUSTER_STR
fi

tail -f /var/log/redis/redis*.log
