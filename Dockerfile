FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive

# LD_LIBRARY_PATH=$PWD ./BloodHound --no-sandbox
# libatk1.0-0 libatk-bridge2.0-0 libgdk-pixbuf2.0-0 libgtk-3-0 libgbm1 libxss1

RUN apt update && apt dist-upgrade -y && \
    apt install -y jq wget gnupg unzip npm libatk1.0-0 libatk-bridge2.0-0 libgdk-pixbuf2.0-0 libgtk-3-0 libgbm1 libxss1 && \
    wget -O- https://debian.neo4j.com/neotechnology.gpg.key | apt-key add - && \
    echo 'deb https://debian.neo4j.com stable latest' >> /etc/apt/sources.list.d/neo4j.list && \
    apt update && \
    echo "neo4j-enterprise neo4j/accept-license select Accept commercial license" | debconf-set-selections && \
    apt install -y neo4j-enterprise && \
    BHPATH=`wget -O- -q https://api.github.com/repos/BloodHoundAD/BloodHound/releases/latest | jq --raw-output '.tarball_url'` && \
    mkdir -p /opt && cd /opt && \
    wget -O bh.tar.gz "$BHPATH" && tar xf bh.tar.gz && rm bh.tar.gz && cd * && \
    npm install && npm run build:linux && \
    cd BloodHound-linux-x64 && ln -s $PWD/BloodHound /BloodHound

COPY run.sh /run.sh

RUN chmod +x /run.sh

ENTRYPOINT "/run.sh"
