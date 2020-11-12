# Docker Angular CLI e2e
Run Angular end-to-end tests with Protractor / Webdriver inside docker container using Google Chrome / chromium.
Works great on CI servers.

Example usage
```
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-e2e ng e2e
```

## Locking the ChromeDriver version
Angular CLI uses webdriver for protractor tests. The npm package to install/update webdriver checks every hour if a new version is available and updates to the latest version. This might break your build if webdriver requires a later version of the Chrome browser. (See https://github.com/angular/webdriver-manager/blob/HEAD/docs/versions.md )
The solution is to run an update to a fixed version just before the actual build happens. This will prevent installation of a later version.

For example:

```
docker ... trion/ng-cli-e2e:11.0.0 \
    ./node_modules/protractor/bin/webdriver-manager update --versions.chrome 86.0.4240.198 && \
    ng e2e --webdriver-update=false
```
