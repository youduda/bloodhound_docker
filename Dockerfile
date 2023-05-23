FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt dist-upgrade -y && \
    apt install -y wget gnupg unzip libgtk-3-0 libgbm1 && \
    wget -O- https://debian.neo4j.com/neotechnology.gpg.key | apt-key add - && \
    echo 'deb https://debian.neo4j.com stable latest' >> /etc/apt/sources.list.d/neo4j.list && \
    apt update && \
    apt install -y neo4j && \
    mkdir -p /opt && cd /opt && \
    wget -O BloodHound-linux-x64.zip https://github.com/BloodHoundAD/BloodHound/releases/latest/download/BloodHound-linux-x64.zip && \
    unzip BloodHound-linux-x64.zip && \
    rm BloodHound-linux-x64.zip && \
    cd BloodHound-linux-x64 && ln -s $PWD/BloodHound /BloodHound

COPY run.sh /run.sh

RUN chmod +x /run.sh

ENTRYPOINT "/run.sh"
