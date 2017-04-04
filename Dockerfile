FROM debian:sid-slim
MAINTAINER hotio

ARG DEBIAN_FRONTEND=noninteractive
ENV XDG_CONFIG_HOME="/config" \
    XDG_DATA_HOME="/config"
ENV LANG='C.UTF-8' LANGUAGE='C.UTF-8' LC_ALL='C.UTF-8'

# install packages
RUN echo "deb http://deb.debian.org/debian sid main non-free" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
        apt-utils && \
    apt-get upgrade -y && \
    apt-get install -y \
        ca-certificates \
        jq \
        curl \
        python \
        unrar \
        unzip \
        p7zip-full && \

# install s6-overlay
    curl -s -o /tmp/s6-overlay.tar.gz -L "https://github.com/just-containers/s6-overlay/releases/download/v1.19.1.1/s6-overlay-amd64.tar.gz" && \
    tar xzf /tmp/s6-overlay.tar.gz -C / --exclude="./bin" && \
    tar xzf /tmp/s6-overlay.tar.gz -C /usr ./bin && \

# create user
    useradd -u 1000 -U -d /config -s /bin/false hotio && \
    usermod -G users hotio && \

# make folders
    mkdir -p \
	    /app \
	    /config && \

# clean up
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

COPY root/ /

ENTRYPOINT ["/init"]
