FROM alpine:latest

RUN apk add dos2unix --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted

RUN apk --update add bash && apk --no-cache add wget curl

RUN apk add --update ca-certificates openssl tar && \
    wget https://github.com/coreos/etcd/releases/download/v3.2.0-rc.0/etcd-v3.2.0-rc.0-linux-amd64.tar.gz && \
    tar zxvf etcd-v3.2.0-rc.0-linux-amd64.tar.gz && \
    mv etcd-v3.2.0-rc.0-linux-amd64/etcd* /bin/ && \
    apk del --purge tar openssl && \
    rm -Rf etcd-v3.2.0-rc.0-linux-amd64* /var/cache/apk/*

VOLUME /data
EXPOSE 2379 2380 4001 7001
ADD run.sh /bin/run.sh
RUN chmod -R 755 /bin/run.sh
RUN dos2unix /bin/run.sh
ENTRYPOINT ["/bin/run.sh"]
