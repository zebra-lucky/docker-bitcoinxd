FROM ubuntu:xenial
MAINTAINER Kyle Manna <kyle@kylemanna.com>

ARG USER_ID
ARG GROUP_ID

ENV HOME /bitcoinx

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}
RUN groupadd -g ${GROUP_ID} bitcoinx
RUN useradd -u ${USER_ID} -g bitcoinx -s /bin/bash -m -d /bitcoinx bitcoinx

RUN chown bitcoinx:bitcoinx -R /bitcoinx

ADD https://github.com/bitcoinx-project/bitcoinx/releases/download/v0.16.2/bitcoinx-0.16.2-x86_64-linux-gnu.tar.gz /tmp/
RUN tar -xzvf /tmp/bitcoinx-* -C /tmp/ \
    && cp /tmp/bitcoinx-0*/bin/*  /usr/local/bin \
    && cp /tmp/bitcoinx-0*/lib/*  /usr/local/lib \
    && rm -rf /tmp/bitcoinx-0*

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# For some reason, docker.io (0.9.1~dfsg1-2) pkg in Ubuntu 14.04 has permission
# denied issues when executing /bin/bash from trusted builds.  Building locally
# works fine (strange).  Using the upstream docker (0.11.1) pkg from
# http://get.docker.io/ubuntu works fine also and seems simpler.
USER bitcoinx

VOLUME ["/bitcoinx"]

EXPOSE 8332 8333 18332 18333

WORKDIR /bitcoinx

CMD ["btx_oneshot"]
