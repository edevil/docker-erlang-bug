FROM erlang:latest

MAINTAINER André Cruz <andre@cabine.org>

ADD . /test
WORKDIR /test

RUN erlc test.erl
CMD ["erl", "-noshell", "-s", "test", "run", "-s", "init", "stop"]
