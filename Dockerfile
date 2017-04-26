FROM alpine:latest
MAINTAINER Oskari Rauta <oskari.rauta@gmail.com>

ENV TZ=""
ENV LANG="C.UTF-8"
ENV TERM="xterm"
ENV LD_LIBRARY_PATH="/lib:/usr/lib"

RUN apk add --update --no-cache openrc \
 && rm -rf /var/cache/apk/** \
 && rm -rf /etc/init.d/** \
 && rm -f /etc/inittab \
 && rm -f /lib/rc/sh/openrc-run.sh

COPY inittab /etc/inittab
COPY openrc-run.sh /lib/rc/sh/openrc-run.sh

RUN chmod +x /lib/rc/sh/openrc-run.sh

ENTRYPOINT [ "/sbin/init" ]
WORKDIR /
