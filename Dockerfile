FROM arm64v8/alpine:latest
MAINTAINER 1Conan <me@1conan.com>

ENV TZ=""
ENV LANG="C"
ENV LC_ALL="C"
ENV TERM="xterm"
ENV LD_LIBRARY_PATH="/lib:/usr/lib"

RUN apk add --update --no-cache openrc \
 && rm -rf /var/cache/apk/**

# Tell openrc its running inside a container, till now that has meant LXC
RUN sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf \
# Tell openrc loopback and net are already there, since docker handles the networking
 && echo 'rc_provide="loopback net"' >> /etc/rc.conf \
# Allow passing of environment variables for init scripts
 && echo 'rc_env_allow="*"' >> /etc/rc.conf \
# no need for loggers
 && sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf \
# remove sysvinit runlevels
 && sed -i '/::sysinit:/d' /etc/inittab \
# can't get ttys unless you run the container in privileged mode
 && sed -i '/tty/d' /etc/inittab \
# can't set hostname since docker sets it
 && sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname \
# can't mount tmpfs since not privileged
 && sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh \
# can't do cgroups
 && sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh

WORKDIR /

ENTRYPOINT ["/sbin/init"]
