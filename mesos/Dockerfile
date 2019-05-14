FROM ubuntu:18.04

LABEL version="0.1"

ENV OUTPUT_DIR="/opt/artifacts"

RUN mkdir $OUTPUT_DIR
VOLUME $OUTPUT_DIR

# Packaging requirements
# https://github.com/endlessm/mesos-deb-packaging/blob/master/README.md
RUN apt-get update && apt-get -y install git \
                                         build-essential \
                                         ruby \
                                         ruby-dev

RUN gem install fpm

# Mesos build requirements
# XXX: JDK may leave /etc/ssl/certs/java/cacerts empty so we install JDK8 as
#      well so that our cacerts store isn't empty.
#      https://bugs.java.com/view_bug.do?bug_id=8189131
#      https://bugs.openjdk.java.net/browse/JDK-8193890
RUN apt-get -y install git \
                       autoconf \
                       build-essential \
                       libapr1-dev \
                       libcurl4-openssl-dev \
                       libtool \
                       libsasl2-dev \
                       libsvn-dev \
                       maven \
                       openjdk-11-jdk \
                       openjdk-8-jdk \
                       python-dev \
                       zlib1g-dev

ENV MAKEFLAGS=-j2 \
    JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
CMD dd if=/dev/zero of=/swapfile bs=64M count=16 && \
    sudo mkswap /swapfile && \
    sudo swapon /swapfile
#based on http://mesos.apache.org/documentation/latest/building/
CMD git clone https://gitbox.apache.org/repos/asf/mesos.git \
        --branch 1.7.2 \
        --single-branch && \
    cd mesos && \
   ./bootstrap && \
   mkdir build && cd build && \
   ../configure && \
   make
#cp mesos_*.deb $OUTPUT_DIR
