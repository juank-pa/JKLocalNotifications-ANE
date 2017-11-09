echo off

set BUILD_ANE_PATH=%~dp0
call %BUILD_ANE_PATH%prepare_android

echo ****** Creating ANE package *******

call %ADT% -package ^
  -target ane ^
  %EXT_PATH%\%ANE_NAME%.ane ^
  %CONFIG_PATH%\extension_android.xml ^
  -swc %TEMP_PATH%\%ANE_NAME%.swc ^
  -platform Android-ARM ^
  -platformoptions %CONFIG_PATH%\options_android.xml ^
  -C %TEMP_PATH%\android\ .

echo ****** ANE package created *******
echo.