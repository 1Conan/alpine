FROM oskarirauta/alpine:latest
MAINTAINER Oskari Rauta <oskari.rauta@gmail.com>

#ENV LANG="C.UTF-8"
ENV GLIBC_PATH="/glibc"
ENV GLIBC_LIBRARY_PATH="$GLIBC_PATH/lib"
ENV GLIBC_LD_LINUX_SO="$GLIBC_LIBRARY_PATH/ld-linux-x86-64.so.2"
ENV LD_LIBRARY_PATH="/lib:/usr/lib:$GLIBC_PATH/lib"

WORKDIR /tmp

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk add --no-cache xz binutils patchelf \
 && wget http://ftp.debian.org/debian/pool/main/g/glibc/libc6_2.24-9_amd64.deb \
 && wget http://ftp.debian.org/debian/pool/main/g/gcc-4.9/libgcc1_4.9.2-10_amd64.deb \
 && wget http://ftp.debian.org/debian/pool/main/g/gcc-4.9/libstdc++6_4.9.2-10_amd64.deb \

 && for pkg in "libc6 libgcc1 libstdc++6"; do \
        mkdir $pkg; \
        cd $pkg; \
        ar x ../$pkg*.deb; \
        tar -xf data.tar.*; \
        cd ..; \
    done \

 && mkdir -p $GLIBC_LIBRARY_PATH \

 && mv libc6/lib/x86_64-linux-gnu/* $GLIBC_LIBRARY_PATH \
 && mv libgcc1/lib/x86_64-linux-gnu/* $GLIBC_LIBRARY_PATH \
 && mv libstdc++6/usr/lib/x86_64-linux-gnu/* $GLIBC_LIBRARY_PATH \
 && apk del --no-cache xz binutils \
 && rm -rf /tmp/* \
 && rm -f /root/.wget-hsts

WORKDIR /
