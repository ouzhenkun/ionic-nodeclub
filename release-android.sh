#!bin/bash

#ionic build --release android

VERSION=$1
NAME=CordovaApp
APK_PATH=platforms/android/ant-build
rm $APK_PATH/$NAME-$VERSION.apk
Jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore android-release-key.keystore $APK_PATH/$NAME-release-unsigned.apk alias_name
~/android/sdk/build-tools/21.1.2/zipalign -v 4 $APK_PATH/$NAME-release-unsigned.apk $APK_PATH/ionic-nodeclub-$VERSION.apk
