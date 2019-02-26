FROM ubuntu:18.04

RUN apt-get -y update && apt-get -y upgrade && apt-get install -y iputils-ping && apt-get install -y freeipa-client

RUN  apt-get -y autoclean && apt-get -y autoremove && \
     apt-get -y purge $(dpkg --get-selections | grep deinstall | sed s/deinstall//g) && \
     rm -rf /var/lib/apt/lists/*
#RUN echo "10.65.34.106 ipaserver.peploleum.com" | tee -a /etc/hosts
#RUN hostnamectl set-hostname node-01.peploleum.com
#ENTRYPOINT ["ipa-client-install"]
ENTRYPOINT ["sh"]
