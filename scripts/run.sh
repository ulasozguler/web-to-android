#!/bin/bash
set -e
source .env

docker compose up --force-recreate
adb uninstall $PACKAGE 2>/dev/null || true
adb install -r output/$PROJECT.apk 
adb shell am start -n $PACKAGE/.MainActivity
