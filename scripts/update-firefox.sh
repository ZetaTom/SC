#!/bin/bash
# Debian Firefox update script written by ZetaTom (2018)
# This small script allows you to install the latest Firefox (non-ESR) version on Debian (x64 stable)
# replace lang=XX with your desired language
url="https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=de"

if pgrep -x "firefox-bin" > /dev/null
then
        echo "Close Firefox before updating!"
        exit 1
fi

wget -q --show-progress -O /tmp/FirefoxSetup.tar.bz2 $url
if [ $? != 0 ]; then
        echo "Unable to download!"
        exit 1
fi

ver=$(wget -q -o - -S --spider $url | sed '/^.*Location/!d; s/.*releases.//; s/\/linux.*//')
hsha=$(wget -O - -q "http://releases.mozilla.org/pub/firefox/releases/$ver/SHA256SUMS" | grep "linux-x86_64/de/firefox-$ver.tar.bz2" | cut -d" " -f 1)
if [ "$(sha256sum /tmp/FirefoxSetup.tar.bz2 | cut -d" " -f 1)" != "$hsha" ]; then
        echo "Wrong hash!"
else
        echo -e "Passed SHA256!\nCurrent version: $ver\nUnarchiving, this may take some time..."
        rm -rf /opt/firefox/*
        tar xjf /tmp/FirefoxSetup.tar.bz2 --overwrite --totals -C /opt/
        if [ $? != 0 ]; then
                echo "An error occurred while unarchiving!"
        fi
fi
rm /tmp/FirefoxSetup.tar.bz2
echo "Done!"
