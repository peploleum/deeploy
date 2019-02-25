FROM ubuntu:18.04

RUN apt-get -y update && apt-get -y upgrade && apt-get install -y freeipa-client

RUN  apt-get -y autoclean && apt-get -y autoremove && \
     apt-get -y purge $(dpkg --get-selections | grep deinstall | sed s/deinstall//g) && \
     rm -rf /var/lib/apt/lists/*

ENTRYPOINT /usr/sbin/ipa-client-configure-first