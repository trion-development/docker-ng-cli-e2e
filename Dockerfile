FROM trion/ng-cli-karma:alpine

MAINTAINER trion development GmbH "info@trion.de"

USER root

RUN set -xe \
 && apk --no-cache add \
    build-base \
    chromium-chromedriver \
    openjdk8-jre-base

COPY intercept-execve.c /usr/local/src/intercept-execve.c
RUN gcc -shared -fPIC /usr/local/src/intercept-execve.c -o /usr/local/lib/intercept-execve.so \
 && apk del \
    build-base \
  && mkdir /usr/local/sbin

# RUN set -xe \
#  && apk --no-cache add \
#     build-base \
#     chromium-chromedriver \
#     openjdk8-jre-base \
#  && gcc -shared -fPIC /usr/local/src/intercept-execve.c -o /usr/local/lib/intercept-execve.so \
#  && apk del \
#     build-base \
#   && mkdir /usr/local/sbin


#node execution looses environment variables
COPY node-hack.sh /usr/local/sbin/node
ENV LD_PRELOAD /usr/local/lib/intercept-execve.so

USER $USER_ID
