FROM ubuntu:bionic

COPY entrypoint.sh .
COPY install.sh .
RUN apt-get -y update && apt-get -y upgrade && apt-get install -y iputils-ping && apt-get install -y freeipa-client

RUN  apt-get -y autoclean && apt-get -y autoremove && \
     apt-get -y purge $(dpkg --get-selections | grep deinstall | sed s/deinstall//g) && \
     rm -rf /var/lib/apt/lists/*
RUN chmod 755 entrypoint.sh && chmod 755 install.sh
ENTRYPOINT ["sh"]
