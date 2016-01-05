FROM buildpack-deps:jessie

MAINTAINER André Cruz <andre@cabine.org>

RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    && export LANG=en_US.UTF-8 \
    && echo $LANG UTF-8 > /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=$LANG \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/erlang/otp.git

RUN cd otp && git checkout c24a4bf84029d06cc79f49634684cd6d2eeafb62

RUN cd otp \
    && ./otp_build autoconf \
    && ./configure \
    && make -j$(nproc) \
    && make install \
    && rm -rf otp

ADD . /test
WORKDIR /test

RUN erlc test.erl
CMD ["erl", "-noshell", "-s", "test", "run", "-s", "init", "stop"]
