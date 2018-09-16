# docker-ng-cli-e2e
Run Angular end-to-end tests inside docker container using Google Chrome / chromium.
Works great on CI servers.

Example usage
```
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-e2e ng e2e
```

Locking the ChromeDriver version
```
docker ... trion/ng-cli-e2e:6.0.8 \
    ./node_modules/webdriver-manager/bin/webdriver-manager update --versions.chrome 2.41 && \
    ng e2e
```
