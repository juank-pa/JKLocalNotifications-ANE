echo off

set RUN_SCRIPT_PATH=%~dp0
call %RUN_SCRIPT_PATH%..\..\bin\config\config
set BUILD_ANE_PATH=%EXT_PATH%\..\build-ane-android-emulator

call %RUN_SCRIPT_PATH%prepare_android

echo ***** packaging SWF file into APK *****

:: Options: apk, apk-captive-runtime, apk-debug, apk-emulator, apk-profile
call %ADT% -package ^
  -target apk-emulator ^
  -arch x86 ^
  -storetype pkcs12 -keystore %CERT_FILE% ^
  -storepass %CERT_PASS% ^
  -keypass %CERT_PASS% ^
  %RUN_SCRIPT_PATH%%APP_NAME%.apk ^
  %RUN_SCRIPT_PATH%%APP_NAME%-app.xml ^
  %RUN_SCRIPT_PATH%%APP_NAME%.swf ^
  -extdir %EXT_PATH%

:: To install successfully emulator must be running.
:: Create and configure an emulator then run it.
:: Set -device if more than one device is running.
:: To list devices: adt -devices -platform iOS|android

echo **** Install app in Android emulator ******

call %ADT% -installApp ^
  -platform android ^
  -package %APP_NAME%.apk