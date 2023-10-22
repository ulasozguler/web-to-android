#!/bin/bash
set -e
source .env

mkdir -p $OUT_DIR
PROJECT_PATH=$OUT_DIR/$PROJECT
cp -r template/ $PROJECT_PATH/

# replace placeholders
sed -i '' \
    -e "s~\${package_name}~${PACKAGE}~" \
    -e "s~\${webview_url}~${WEBVIEW_URL}~" \
    "$PROJECT_PATH/MainActivity.java"

sed -i '' \
    -e "s~\${package_name}~${PACKAGE}~" \
    -e "s~\${app_name}~${APP_NAME}~" \
    "$PROJECT_PATH/AndroidManifest.xml"

# move files
JAVA_FOLDER=${PACKAGE//./\/}
mkdir -p $PROJECT_PATH/src/$JAVA_FOLDER
mv $PROJECT_PATH/MainActivity.java $PROJECT_PATH/src/$JAVA_FOLDER

