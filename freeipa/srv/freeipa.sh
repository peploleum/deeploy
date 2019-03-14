#!/usr/bin/env bash

if [ $# -lt 3 ]; then
  echo "Usage: freeipa.sh VERB HOSTIP REALM HOSTNAME"
  echo
  echo VERB must be one of:
  echo "  • install"
  echo "  • run "
  echo
  echo HOSTIP must meet the following:
  echo "  • will be the published freeipa IP outside of docker network"
  echo "  • must be a valid IPv4"
  echo
  echo REALM must meet the following:
  echo "  • valid realm name"
  echo
  echo "Examples:"
  echo "  • $0 10.0.0.1 PEPLOLEUM.COM ipaserver.peploleum.com" 
  echo "  • $0 192.168.9.1 MYREALM.DE deutschserver.myrealm.de"
  exit 1
fi

verb=$1
case $verb in
run|install)
  ;;
*)
  echo "error: unknown verb '$verb'"
  exit 1
esac

case $verb in

install)

echo "installing freeipa server with parameters: $1 $2 $3" 
sudo rm -rf data
mkdir data
cp conf/ipa-server-install-options data/
sudo echo '*.*' > data/.gitignore 
sudo echo '/**' >> data/.gitignore 
;;

run)

echo "running freeipa server with parameters: $1 $2 $3" 
;;

esac

docker run --rm --name freeipa-server-container \
        -e IPA_SERVER_IP=$1 -e PASSWORD=adminadmin -p 153:53/udp -p 153:53 \
            -p 180:80 -p 443:443 -p 389:389 -p 636:636 -p 88:88 -p 464:464 \
        -p 88:88/udp -p 464:464/udp -p 123:123/udp -p 7389:7389 \
        -p 19443:9443 -p 19444:9444 -p 19445:9445 \
        -ti -h $3 \
        -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
        --tmpfs /run --tmpfs /tmp \
        -v $PWD/data:/data peploleum/freeipa-server -r $2 -U