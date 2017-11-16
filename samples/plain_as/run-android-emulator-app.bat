echo off

set RUN_SCRIPT_PATH=%~dp0
call ..\..\bin\config\config
set BUILD_ANE_PATH=%EXT_PATH%\..\build-ane-android-emulator

call prepare_android

echo ***** packaging SWF file into APK *****

:: Options: apk, apk-captive-runtime, apk-debug, apk-emulator, apk-profile
call %ADT% -package ^
  -target apk-emulator ^
  -arch x86 ^
  -storetype pkcs12 -keystore %CERT_FILE% ^
  -storepass %CERT_PASS% ^
  -keypass %CERT_PASS% ^
  %APP_NAME%.apk ^
  %APP_NAME%-app.xml ^
  %APP_NAME%.swf ^
  fx05.wav ^
  -extdir %EXT_PATH%

:: To install successfully emulator must be running.
:: Create and configure an emulator then run it.
:: Set -device if more than one device is running.
:: To list devices: adt -devices -platform iOS|android

echo **** Install app in Android emulator ******

call %ADT% -installApp ^
  -platform android ^
  -package %APP_NAME%.apk