FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade && apt-get install -y freeipa-client
ENTRYPOINT /usr/sbin/ipa-client-configure-first