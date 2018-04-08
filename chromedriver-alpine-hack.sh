#!/bin/sh

trap 'true' SIGTERM
trap 'true' SIGINT

echo "Patching alpine chromedriver to node_modules..."
rm -f /app/node_modules/protractor/node_modules/webdriver-manager/selenium/chromedriver*
cp $CHROMEDRIVER_FILEPATH /app/node_modules/protractor/node_modules/webdriver-manager/selenium/chromedriver_2.37.zip
unzip -p /app/node_modules/protractor/node_modules/webdriver-manager/selenium/chromedriver_2.37.zip > /app/node_modules/protractor/node_modules/webdriver-manager/selenium/chromedriver_2.37
chmod +x /app/node_modules/protractor/node_modules/webdriver-manager/selenium/chromedriver_2.37
#appear fresh
touch /app/node_modules/protractor/node_modules/webdriver-manager/selenium/chromedriver_2.37.zip /app/node_modules/protractor/node_modules/webdriver-manager/selenium/chromedriver_2.37

cleanup() {
    echo "Removing alpine chromedriver from node_modules ..."
    #rm -f /app/node_modules/protractor/node_modules/webdriver-manager/selenium/chromedriver*
}

echo "Executing command: ${@}"

"${@}" &

wait $!

cleanup
