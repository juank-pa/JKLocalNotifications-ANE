echo off

:: Paths
set SDK=%HOMEPATH%\Developer\AIR_SDK
set AMXML=%SDK%\bin\amxmlc
set ADL=%SDK%\bin\adl
set DEBUG=true

echo Compiling iOS version
call %AMXML% -swf-version 37 ^
  -debug=%DEBUG% ^
  -define+=CONFIG::device,true ^
  -define+=CONFIG::iphone,true ^
  -define+=CONFIG::android,false ^
  -library-path=.\tests\lib\mock4as.swc ^
  -source-path+=.\tests\src\ ^
  -source-path+=.\src\ ^
  -output .\tests\tests.swf ^
  -- .\tests\src\Main.as

echo .
echo Running tests for iOS
call %ADL% .\tests\TestApp.xml .\tests

echo Compiling Android version
call %AMXML% -swf-version 37 ^
  -debug=%DEBUG% ^
  -define+=CONFIG::device,true ^
  -define+=CONFIG::iphone,false ^
  -define+=CONFIG::android,true ^
  -library-path=.\tests\lib\mock4as.swc ^
  -source-path+=.\tests\src\ ^
  -source-path+=.\src\ ^
  -output .\tests\tests.swf ^
  -- .\tests\src\Main.as

echo .
echo Running tests for Android
call %ADL% .\tests\TestApp.xml .\tests

echo Compiling Default version
call %AMXML% -swf-version 37 ^
  -debug=%DEBUG% ^
  -define+=CONFIG::device,false ^
  -define+=CONFIG::iphone,true ^
  -define+=CONFIG::android,true ^
  -library-path=.\tests\lib\mock4as.swc ^
  -source-path+=.\tests\src\ ^
  -source-path+=.\src\ ^
  -output .\tests\tests.swf ^
  -- .\tests\src\Main.as

echo .
echo Running tests for Default
call %ADL% .\tests\TestApp.xml .\tests
