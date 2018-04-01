CONFIG_SCRIPT_PATH="$(dirname "$0")"

# path to YOUR Android SDK
SDK_PATH="$HOME/Developer/AIR_SDK"

# path to the ACOMP tool in AIR sdks
ACOMPC="$SDK_PATH/bin/acompc"

# path to the ADT tool in AIR sdks
ADT="$SDK_PATH/bin/adt"
AMXML="$SDK_PATH/bin/amxmlc"

# AS3 lib folder
LIB_FOLDER=$CONFIG_SCRIPT_PATH/../../src/AS
SWF_VERSION=37

# ANDROID
# path to android sdk
AIR_ANDROID_SDK_HOME="$HOME/android-sdk-macosx"
# native Eclipse project folder
NATIVE_ANDROID_FOLDER=$CONFIG_SCRIPT_PATH/../../src/AndroidStudio
JAR_NAME=localnotification.jar

# IOS
# native XCode project folder
NATIVE_XCODE_FOLDER=$CONFIG_SCRIPT_PATH/../../src/XCode/LocalNotificationLib
IOS_LIB_NAME=LocalNotificationLib
# the "name" must be the name of your physical device as listed in the XCode organizer.
# your device needs to be connected in order to compile the library.
# if you are compiling for iOS simulator these variables are ignored.
PLATFORM="platform=iOS,name=iPad"
# update this to match the configuration used to compile the .a library
# it can be Release or Debug
CONFIGURATION=Release

# name of ANE file
ANE_NAME=LocalNotificationLib

# helpers
TEMP_PATH=$CONFIG_SCRIPT_PATH/../tmp
CONFIG_PATH=$CONFIG_SCRIPT_PATH/../config
EXT_PATH=$CONFIG_SCRIPT_PATH/../ext
