# (Any Docker image can be used as a base. For example, to build on Ubuntu 17,
#  you could have specified ubuntu:17.04. See https://hub.docker.com/ for
#  images that are available on DockerHub)
FROM ubuntu:16.04

MAINTAINER doitmagic <razvan@doitmagic.com>

# Install libraries as you would on a Debian machine. Remember that the golang
# base image is built on a debian image.
RUN apt-get update -qq \
    && apt-get install -yq cmake \
                           fceux \
                           gcc \
                           libboost-all-dev \
                           libjpeg-dev \
                           libsdl2-dev \
                           make \
                           unzip \
                           wget \
                           zlib1g-dev \
                           supervisor \
                           git \
                           curl \
                           mercurial
                        

# Install go tarball
ENV GOLANG_VERSION 1.9.2
RUN wget -qO- http://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz | tar -C /usr/local -xzf -

# Set user

ENV HOME /root
RUN mkdir ${HOME}/go
ENV GOPATH ${HOME}/go
ENV PATH ${PATH}:${GOPATH}/bin:/usr/local/go/bin
WORKDIR ${HOME}/go


# Define mountable directories.
VOLUME ${HOME}/go
VOLUME ["/etc/supervisor/conf.d"]

RUN go get -u github.com/revel/revel
RUN go get -u github.com/revel/cmd/revel

# clear apt cache and remove unnecessary packages
RUN apt-get autoclean && apt-get -y autoremove

EXPOSE 9000


CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
