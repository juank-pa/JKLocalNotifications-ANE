set CONFIG_SCRIPT_PATH=%~dp0

:: path to YOUR Android SDK
set SDK_PATH=%HOMEPATH%\Developer\AIR_SDK

:: path to the ACOMP tool in AIR sdks
set ACOMPC=%SDK_PATH%\bin\acompc

:: path to the ADT tool in AIR sdks
set ADT=%SDK_PATH%\bin\adt

set AMXML=%SDK_PATH%\bin\amxmlc

:: AS3 lib folder
set LIB_FOLDER=%CONFIG_SCRIPT_PATH%..\..\src\AS
set SWF_VERSION=37

:: ANDROID
:: path to android sdk
set AIR_ANDROID_SDK_HOME=%HOMEPATH%\android-sdk-macosx
:: native Eclipse project folder
set NATIVE_ANDROID_FOLDER=%CONFIG_SCRIPT_PATH%..\..\src\AndroidStudio
set JAR_NAME=localnotification.jar

:: IOS
:: native XCode project folder
set NATIVE_XCODE_FOLDER=%CONFIG_SCRIPT_PATH%..\..\src\XCode\LocalNotificationLib
set IOS_LIB_NAME=LocalNotificationLib
:: the name must be the name of your physical device as listed in the XCode organizer.
:: your device needs to be connected in order to compile the library.
:: if you are compiling for iOS simulator these variables are ignored.
set PLATFORM=platform=iOS,name=iPad
:: update this to match the configuration used to compile the .a library
:: it can be Release or Debug
set CONFIGURATION=Release

:: name of ANE file
set ANE_NAME=LocalNotificationLib

:: helpers
set TEMP_PATH=%CONFIG_SCRIPT_PATH%..\tmp
set CONFIG_PATH=%CONFIG_SCRIPT_PATH%..\config
set EXT_PATH=%CONFIG_SCRIPT_PATH%..\ext
