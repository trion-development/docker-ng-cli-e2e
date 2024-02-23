FROM trion/ng-cli-karma:17.2.1

LABEL ng-cli-karma='17.2.0'

ARG USER_ID=1000
USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
		bzip2 \
		unzip \
		xz-utils \
		apt-transport-https \
		ffmpeg \
		openjdk-17-jre \
		ca-certificates p11-kit \
	&& rm -rf /var/lib/apt/lists/*


USER $USER_ID
