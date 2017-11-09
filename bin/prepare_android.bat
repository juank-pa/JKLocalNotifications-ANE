set SCRIPT_PATH=%~dp0
call %SCRIPT_PATH%config\config

rmdir /S /Q %TEMP_PATH%

echo ****** ANDROID VERSION *******

mkdir %TEMP_PATH%
mkdir %TEMP_PATH%\app-debug
mkdir %TEMP_PATH%\android

echo ****** Copying native library *******

:: TODO: Try to automatize Android compilation
::jar cf %TEMP_PATH%\android\%JAR_NAME% -C .\%NATIVE_ANDROID_FOLDER%\bin .

7za x -bso0 -r -o%TEMP_PATH%\app-debug %NATIVE_ANDROID_FOLDER%\app\build\outputs\aar\app-debug.aar
xcopy /E /I /Q %TEMP_PATH%\app-debug\res %TEMP_PATH%\android\res

copy %TEMP_PATH%\app-debug\classes.jar %TEMP_PATH%\android\%JAR_NAME%
copy %NATIVE_ANDROID_FOLDER%\app\libs\support-v4.jar %TEMP_PATH%\android
copy %NATIVE_ANDROID_FOLDER%\app\libs\support-compat.jar %TEMP_PATH%\android

xcopy /E /Q %SCRIPT_PATH%res %TEMP_PATH%\android\res

echo ****** Compiling AS3 library *******

call %ACOMPC% ^
    -swf-version %AIR_VERSION% ^
    -define+=CONFIG::device,true ^
    -define+=CONFIG::iphone,false ^
    -define+=CONFIG::android,true ^
    -source-path %LIB_FOLDER%\src\ ^
    -output %TEMP_PATH%\%ANE_NAME%.swc ^
    -include-sources %LIB_FOLDER%\src\

echo ****** Extracting compiled data *******

7za x -bso0 -o%TEMP_PATH% %TEMP_PATH%\%ANE_NAME%.swc
move %TEMP_PATH%\library.swf %TEMP_PATH%\android
del %TEMP_PATH%\catalog.xml

echo ****** END ANDROID VERSION *******
echo.