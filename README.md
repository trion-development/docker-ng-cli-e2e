# docker-ng-cli-e2e
Run Angular end2end tests inside docker container using Google Chrome / chromium.
Works great on CI servers.

Example usage
```
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-e2e ng e2e
```
