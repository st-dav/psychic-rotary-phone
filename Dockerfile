FROM ubuntu:21.04

# Make sure that the underlying container is patched to the latest versions
RUN apt update && \
    apt install -y wget tar gzip && \
    rm -rf /var/lib/apt/lists/*

# Now install Focalboard as a seperate layer
RUN wget https://github.com/mattermost/focalboard/releases/download/v0.6.1/focalboard-server-linux-amd64.tar.gz && \
    tar -xvzf focalboard-server-linux-amd64.tar.gz && \
    mv focalboard /opt

# multi-stage build
FROM ubuntu:21.04

# update system
RUN apt update && \
    apt install -y nginx && \
    rm -rf /var/lib/apt/lists/*

# configure nginx
COPY nginx-site /etc/nginx/sites-enabled/focalboard

# add non root user
RUN useradd -d /home/focalboard -m -s /bin/bash focalboard && \
    echo "focalboard:focalboard" | chpasswd && adduser focalboard sudo

# gert interesting stuff from builder image
WORKDIR /opt/focalboard
COPY --from=0 /opt/focalboard .

RUN chown -R focalboard:focalboard /opt/focalboard

EXPOSE 8000

USER focalboard
##CMD [ "/opt/focalboard/bin/focalboard-server" ]
