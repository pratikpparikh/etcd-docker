#!/bin/sh

set -e

IFACE=${1:-eth0}

IP=`ifconfig $IFACE | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1`
URL="http://${IP}"

# check for $CLIENT_URLS
if [ -z ${CLIENT_URLS+x} ]; then
    CLIENT_URLS="${URL}:4001,${URL}:2379"
    echo "Using default CLIENT_URLS ($CLIENT_URLS)"
else
    echo "Detected new CLIENT_URLS value of $CLIENT_URLS"
fi

# check for $PEER_URLS

if [ -z ${PEER_URLS+x} ]; then
    PEER_URLS="${URL}:7001,${URL}:2380"
    echo "Using default PEER_URLS ($PEER_URLS)"
else
    echo "Detected new PEER_URLS value of $PEER_URLS"
fi

ETCD_CMD="/bin/etcd -data-dir=/data -listen-peer-urls=${PEER_URLS} -listen-client-urls=http://0.0.0.0:2379,http://0.0.0.0:4001 --advertise-client-urls=${CLIENT_URLS} $*"
echo -e "Running '$ETCD_CMD'\nBEGIN ETCD OUTPUT\n"

exec $ETCD_CMD
