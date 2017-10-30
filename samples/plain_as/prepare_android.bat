set PREPARE_SCRIPT_PATH=%~dp0

:: name of APP file
set APP_NAME=sample

:: Certificate password
set CERT_FILE=%PREPARE_SCRIPT_PATH%test_android.p12
set CERT_PASS=1234

set RES_PATH=%EXT_PATH%\..\res

echo ***** COPYING ANE RESOURCES *****
rmdir /S /Q %RES_PATH%
xcopy /E /I /Q %PREPARE_SCRIPT_PATH%res %RES_PATH%

call %BUILD_ANE_PATH%

rmdir /S /Q %RES_PATH%

echo ***** ANDROID EMULATOR APP ******
echo ***** compiling SWF file *****

call %AMXML% -swf-version %AIR_VERSION% ^
  -define+=CONFIG::device,true ^
  -define+=CONFIG::iphone,false ^
  -define+=CONFIG::android,true ^
  -external-library-path+=%EXT_PATH%\LocalNotificationLib.ane ^
  -output %PREPARE_SCRIPT_PATH%%APP_NAME%.swf ^
  -- %PREPARE_SCRIPT_PATH%Sample.as