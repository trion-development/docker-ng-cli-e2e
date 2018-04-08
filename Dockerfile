FROM trion/ng-cli-karma:alpine

MAINTAINER trion development GmbH "info@trion.de"

USER root
COPY intercept-execve.c /usr/local/src/intercept-execve.c

RUN set -xe \
 && apk --no-cache add \
    build-base \
    chromium-chromedriver \
    openjdk8-jre-base \
 && gcc -shared -fPIC /usr/local/src/intercept-execve.c -o /usr/local/lib/intercept-execve.so \
 && apk del \
    build-base

ENV LD_PRELOAD /usr/local/lib/intercept-execve.so

USER $USER_ID
