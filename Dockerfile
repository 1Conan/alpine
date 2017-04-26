FROM alpine:latest
MAINTAINER Oskari Rauta <oskari.rauta@gmail.com>

ENV TZ=""
ENV LANG="C.UTF-8"
ENV TERM="xterm"
ENV LD_LIBRARY_PATH="/lib:/usr/lib"

apk add --update --no-cache openrc

RUN rm -rf /var/cache/apk/**
