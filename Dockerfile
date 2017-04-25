FROM oskarirauta/alpine:latest
MAINTAINER Oskari Rauta <oskari.rauta@gmail.com>

RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" \
 && ALPINE_GLIBC_PACKAGE_VERSION="2.25-r0" \
 && ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" \
 && ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" \
 && ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" \
 && apk add --no-cache --virtual=.build-dependencies wget ca-certificates \
 && wget \
      "https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/sgerrand.rsa.pub" \
      -O "/etc/apk/keys/sgerrand.rsa.pub" \
 && wget \
      "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
      "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
      "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" \
 && apk add --no-cache \
      "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
      "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
      "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" \

 && rm "/etc/apk/keys/sgerrand.rsa.pub" \
 && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true \
 && echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh \

 && apk del glibc-i18n \
 
 && rm "/root/.wget-hsts" \
 && apk del .build-dependencies \
 && rm \
      "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
      "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
      "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"

ENV GLIBC_PATH="/usr/glibc-compat"
ENV GLIBC_LIBRARY_PATH="$GLIBC_PATH/lib"
ENV GLIBC_LD_LINUX_SO="$GLIBC_LIBRARY_PATH/ld-linux-x86-64.so.2"
ENV LD_LIBRARY_PATH="/lib:/usr/lib:$GLIBC_PATH/lib"
