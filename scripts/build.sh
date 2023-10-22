#!/bin/bash
set -e

# setup folders
OBJ_DIR=obj
GEN_DIR=gen
PRE_SIGN_APK=app.unaligned.apk
DEX_FILE=classes.dex
PROJECT_DIR=$PROJECT

echo "Started"

# create and work on output folder
mkdir -p $OUT_DIR
pushd $OUT_DIR > /dev/null

# setup environment
PATH="/opt/android-sdk/build-tools/$BUILD_TOOLS_VERSION:$PATH"
ANDROID_JAR=/opt/android-sdk/platforms/android-$ANDROID_VERSION/android.jar
jenv local $JAVA_VERSION

# create folders
mkdir -p $OBJ_DIR $GEN_DIR

# build apk
echo "Building APK"
JAVA_FOLDER=${PACKAGE//./\/}
aapt package -m -J $GEN_DIR -M $PROJECT_DIR/AndroidManifest.xml -S $PROJECT_DIR/res/ -I $ANDROID_JAR
javac \
    -d $OBJ_DIR \
    -classpath $ANDROID_JAR:$GEN_DIR \
    -sourcepath $PROJECT_DIR/src:$GEN_DIR \
    $PROJECT_DIR/src/$JAVA_FOLDER/*.java

# support older android versions
if which dx &>/dev/null; then
    dx --dex --output=$DEX_FILE $OBJ_DIR
else
    find $OBJ_DIR -name "*.class" | xargs d8
fi

aapt package -f -m -F $PRE_SIGN_APK -M $PROJECT_DIR/AndroidManifest.xml -I $ANDROID_JAR -S $PROJECT_DIR/res/
aapt add $PRE_SIGN_APK $DEX_FILE > /dev/null

# sign the apk
echo "Signing APK"
if [ ! -f $KEY_PATH ]; then  # skip certicate creation if already created
    echo "Certificate not found, generating new one."
    keytool -genkey -v \
            -keystore $KEY_PATH \
            -storepass $KEY_STOREPASS \
            -alias $KEY_ALIAS \
            -keypass $KEY_PASS \
            -storetype PKCS12 \
            -keyalg RSA \
            -keysize 2048 \
            -validity 10000 \
            -dname "$KEY_DNAME"
fi
APK_PATH=$PROJECT.apk
apksigner sign --ks $KEY_PATH --ks-pass pass:$KEY_PASS --out $APK_PATH $PRE_SIGN_APK

# cleanup
echo "Cleaning up"
rm -r $GEN_DIR $OBJ_DIR $PRE_SIGN_APK $DEX_FILE .java-version

echo "Generated: $OUT_DIR/$APK_PATH"

popd > /dev/null
