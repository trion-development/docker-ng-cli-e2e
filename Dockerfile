FROM trion/ng-cli-karma:alpine

MAINTAINER trion development GmbH "info@trion.de"

USER root

ENV CHROMEDRIVER_FILEPATH '/chromedriver.zip'
ENV CHROMEDRIVER_PATH '/usr/bin/chromedriver'
COPY chromedriver-alpine-hack.sh /chromedriver-alpine-hack.sh

RUN apk --no-cache add \
		chromium-chromedriver \
		zip unzip \
		openjdk8-jre-base && \
		zip -j -D /chromedriver.zip /usr/bin/chromedriver

#zip chromedriver as chromedriver_linux64.zip
#move binary to different location

# RUN apk --no-cache add ca-certificates openssl && \
#     wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
#     apk --no-cache -X https://apkproxy.herokuapp.com/sgerrand/alpine-pkg-glibc add \
# 		 glibc \
# 		 glibc-bin \
# 		 openjdk8-jre-base && \
# 		 /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib

USER $USER_ID

ENTRYPOINT ["/chromedriver-alpine-hack.sh"]
