FROM ubuntu:21.04

# Make sure that the underlying container is patched to the latest versions
RUN apt update && \
    apt install -y wget tar gzip

RUN useradd -d /home/focalboard -m -s /bin/bash focalboard && \
    echo "focalboard:focalboard" | chpasswd && adduser focalboard sudo

# Now install Focalboard as a seperate layer
RUN wget https://github.com/mattermost/focalboard/releases/download/v0.6.1/focalboard-server-linux-amd64.tar.gz && \
    tar -xvzf focalboard-server-linux-amd64.tar.gz && \
    mv focalboard /opt

RUN chown -R focalboard:focalboard /opt/focalboard

EXPOSE 8000

USER focalboard
WORKDIR /opt/focalboard




