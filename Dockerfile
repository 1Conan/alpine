FROM oskarirauta/alpine:latest
MAINTAINER Oskari Rauta <oskari.rauta@gmail.com>

#ENV LANG="C.UTF-8"
ENV GLIBC_PATH="/glibc"
ENV GLIBC_LIBRARY_PATH="$GLIBC_PATH/lib"
ENV GLIBC_LD_LINUX_SO="$GLIBC_LIBRARY_PATH/ld-linux-x86-64.so.2"
ENV LD_LIBRARY_PATH="/lib:/usr/lib:$GLIBC_LIBRARY_PATH"

RUN cd /tmp \
 && apk add --no-cache --repository "http://dl-cdn.alpinelinux.org/alpine/edge/testing" xz binutils patchelf \
 && wget http://ftp.debian.org/debian/pool/main/g/glibc/libc6_2.24-10_amd64.deb \
 && wget http://ftp.debian.org/debian/pool/main/g/gcc-4.9/libgcc1_4.9.2-10_amd64.deb \
 && wget http://ftp.debian.org/debian/pool/main/g/gcc-4.9/libstdc++6_4.9.2-10_amd64.deb

RUN mkdir "/tmp/libc6" "/tmp/libgcc1" "/tmp/libstdc++6" \
 
 && cd /tmp/libc6 \
 && ar x /tmp/libc6_2.24-10_amd64.deb \
 && tar -xf data.tar.xz \

 && cd /tmp/libgcc1 \
 && ar x /tmp/libgcc1_4.9.2-10_amd64.deb \
 && tar -xf data.tar.xz \

 && cd /tmp/libstdc++6 \
 && ar x /tmp/libstdc++6_4.9.2-10_amd64.deb \
 && tar -xf data.tar.xz

RUN mkdir -p $GLIBC_LIBRARY_PATH \

 && mv /tmp/libc6/lib/x86_64-linux-gnu/** $GLIBC_LIBRARY_PATH \
 && mv /tmp/libgcc1/lib/x86_64-linux-gnu/** $GLIBC_LIBRARY_PATH \
 && mv /tmp/libstdc++6/usr/lib/x86_64-linux-gnu/** $GLIBC_LIBRARY_PATH

RUN apk del --no-cache xz binutils \
 && rm -rf /tmp/* \
 && rm -f /root/.wget-hsts
