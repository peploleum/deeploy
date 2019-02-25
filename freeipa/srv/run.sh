#!/usr/bin/env bash

sudo rm -rf data
mkdir data
cp conf/ipa-server-install-options data/
sudo echo '*.*' > data/.gitignore 
sudo echo '/**' >> data/.gitignore 
docker run --rm --name freeipa-server-container \
        -e IPA_SERVER_IP=10.65.34.106 -e PASSWORD=adminadmin -p 153:53/udp -p 153:53 \
            -p 180:80 -p 443:443 -p 389:389 -p 636:636 -p 88:88 -p 464:464 \
        -p 88:88/udp -p 464:464/udp -p 123:123/udp -p 7389:7389 \
        -p 19443:9443 -p 19444:9444 -p 19445:9445 \
        -ti -h ipaserver.peploleum.com \
        -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
        --tmpfs /run --tmpfs /tmp \
        -v $PWD/data:/data peploleum/freeipa-server -r PEPLOLEUM.COM -U
