echo off

set RUN_SCRIPT_PATH=%~dp0
call %RUN_SCRIPT_PATH%..\..\bin\config\config
set BUILD_ANE_PATH=%EXT_PATH%\..\build-ane-android

call %RUN_SCRIPT_PATH%\prepare_android

echo ***** packaging SWF file into APK *****

:: Options: apk, apk-captive-runtime, apk-debug, apk-emulator, apk-profile
call %ADT% -package ^
  -target apk-captive-runtime ^
  -storetype pkcs12 -keystore %CERT_FILE% ^
  -storepass %CERT_PASS% ^
  -keypass %CERT_PASS% ^
  %APP_NAME%.apk ^
  %APP_NAME%-app.xml ^
  %APP_NAME%.swf ^
  -extdir %EXT_PATH%

:: For these steps the device must be running
:: Set -device if more than one device is running.
:: To list devices: adt -devices -platform iOS|android

echo **** Install app in Android emulator ******

call %ADT% -installApp ^
  -platform android ^
  -package %APP_NAME%.apk
