FROM ubuntu:16.04
MAINTAINER Nitesh Oswal <nit.oswal@gmail.com>
RUN apt-get update


ENV MONGO_MAJOR 3.2
ENV MONGO_VERSION 3.2.10
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
RUN echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/$MONGO_MAJOR multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org.list
RUN apt-get update\
    && \
        apt-get install -y --force-yes \
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
RUN \
echo "[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target
Documentation=https://docs.mongodb.org/manual

[Service]
User=mongodb
Group=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target" >> /lib/systemd/system/mongod.service

EXPOSE 27017
RUN systemctl start mongod.service

ENTRYPOINT $(which mongo)