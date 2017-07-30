# path to YOUR Android SDK
SDK_PATH="$HOME/Developer/AIR_SDK"

# path to the ACOMP tool in AIR sdks
ACOMPC="$SDK_PATH/bin/acompc"

# path to the ADT tool in AIR sdks
ADT="$SDK_PATH/bin/adt"

# AS3 lib folder
LIB_FOLDER=./../src/AS
AIR_VERSION=26

# ANDROID
# path to android sdk
AIR_ANDROID_SDK_HOME="$HOME/android-sdk-macosx"
# native Eclipse project folder
NATIVE_ANDROID_FOLDER=./../src/Eclipse
JAR_NAME=localnotification.jar

# IOS
# native XCode project folder
NATIVE_XCODE_FOLDER=./../src/XCode/LocalNotificationLib
IOS_LIB_NAME=LocalNotificationLib
# the "name" must be the name of your physical device as listed in the XCode organizer.
# your device needs to be connected in order to compile the library.
# if you are compiling for iOS simulator these variables are ignored.
PLATFORM="platform=iOS,name=iPad"
CONFIGURATION=Release

# name of ANE file
ANE_NAME=LocalNotificationLib

# helpers
TEMP_PATH=./tmp
CONFIG_PATH=./config
RESULT_PATH=./ext