FROM ubuntu:16.04
MAINTAINER Nitesh Oswal <nit.oswal@gmail.com>
RUN apt-get update


ENV MONGO_MAJOR 3.2
ENV MONGO_VERSION 3.2.10
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/$MONGO_MAJOR multiverse" | tee /etc/apt/sources.list.d/mongodb-org.list
RUN apt-get update\
    && \
        apt-get install -y --allow-unauthenticated \
            wget \
            mongodb-org=$MONGO_VERSION \
            mongodb-org-server=$MONGO_VERSION \
            mongodb-org-shell=$MONGO_VERSION \
            mongodb-org-mongos=$MONGO_VERSION \
            mongodb-org-tools=$MONGO_VERSION \
    && \
        echo "mongo-org hold" | dpkg --set-selections \
    && \
        echo "mongo-org-server hold" | dpkg --set-selections \
    && \
        echo "mongo-org-shell hold" | dpkg --set-selections \
    && \
        echo "mongo-org-mongos hold" | dpkg --set-selections \
    && \
        echo "mongo-org-tools hold" | dpkg --set-selections


# Create that mongo.service unit for systemd
RUN wget https://rawgit.com/NiteshOswal/docker-mongo/master/mongod.service > /lib/systemd/system/mongod.service

VOLUME [ “/sys/fs/cgroup” ]

RUN systemctl start mongod.service
EXPOSE 27017

ENTRYPOINT /usr/bin/mongo