FROM openjdk:8u131-jdk

RUN mkdir /app

RUN cd app && wget https://github.com/JanusGraph/janusgraph/releases/download/v0.3.1/janusgraph-0.3.1-hadoop2.zip
RUN apt-get update && apt-get install -y \
    unzip

RUN cd app && unzip janusgraph-0.3.1-hadoop2.zip && rm janusgraph-0.3.1-hadoop2.zip && cd janusgraph-0.3.1-hadoop2

WORKDIR /app/janusgraph-0.3.1-hadoop2

EXPOSE 8182
