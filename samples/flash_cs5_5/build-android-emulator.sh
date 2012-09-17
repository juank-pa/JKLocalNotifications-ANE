# path to YOUR Android SDK
export AIR_ANDROID_SDK_HOME="/Users/juancarlos/android-sdk-macosx"

# path to the ADT tool in Flash Builder sdks
ACOMPC="/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin/acompc"

# path to the ADT tool in Flash Builder sdks
ADT="/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin/adt"

# native Android project folder
NATIVE_XCODE_FOLDER=../src/XCode/LocalNotificationLib

# AS lib folder
LIB_FOLDER=../src/FlashBuilder

# name of APP file
APP_NAME=sample

# Certificate password
CERT_PASS=1234

#===================================================================

echo "***** ANDROID EMULATOR APP ******"
echo "***** packaging SWF file *****"

"$ADT" -package -target apk-emulator -storetype pkcs12 -keystore test.p12 -storepass ${CERT_PASS} -keypass ${CERT_PASS} ${APP_NAME}.apk ${APP_NAME}-app.xml -extdir ../../bin ${APP_NAME}.swf

# For this steps emulator must be running
# Create and configure an emulator then run it
# To run use: emulator ave Test_Device_Name
# To list devices: adb devices
# debugger: platform-tools/adb log cat

echo "**** Install AIR SDK in Android emulator *****"
"$ADT" -installRuntime -platform android -platformsdk "$AIR_ANDROID_SDK_HOME"

echo "**** Install app in Android emulator ******"

"$ADT" -installApp -platform android -platformsdk "$AIR_ANDROID_SDK_HOME" -package ${APP_NAME}.apk





#**** Package for iOS *******

#"/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin/adt" -package -target ipa-ad-hoc -storetype pkcs12 -keystore iphone_dev.p12 -provisioning-profile TESTDEVIPOD.mobileprovision sample.ipa sample-app.xml sample.swf fx05.caf -extdir ../../bin -platformsdk /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS5.1.sdk/


#**** Package for Android device ******

#"/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin/adt" -package -target apk -storetype pkcs12 -keystore test.p12 test.apk test-app.xml -extdir ../../bin test.swf fx05.wav

#Note: password is 1234


