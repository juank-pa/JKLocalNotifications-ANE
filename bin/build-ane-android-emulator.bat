echo off

set SCRIPT_PATH=%~dp0
call %SCRIPT_PATH%/config/config.sh
rmdir /S /Q %TEMP_PATH%

call %SCRIPT_PATH%prepare_android

echo ****** Creating ANE package *******

call %ADT% -package ^
  -target ane ^
  %EXT_PATH%\%ANE_NAME%.ane ^
  %CONFIG_PATH%\extension_android_emulator.xml ^
  -swc %TEMP_PATH%\%ANE_NAME%.swc ^
  -platform Android-x86 ^
  -platformoptions %CONFIG_PATH%\options_android.xml ^
  -C %TEMP_PATH%\android\ .

echo ****** ANE package created *******
echo.