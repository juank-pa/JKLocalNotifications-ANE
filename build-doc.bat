

set SDK_PATH=%HOMEPATH%\Developer\AIR_SDK
set ASDOC_PATH=%SDK_PATH%\bin\asdoc

rmdir doc /s /q

%ASDOC_PATH% ^
  -define+=CONFIG::device,false ^
  -define+=CONFIG::iphone,false ^
  -define+=CONFIG::android,false ^
  -library-path+=%SDK_PATH%\frameworks\libs\air\airglobal.swc ^
  -source-path .\src\AS\src ^
  -doc-sources .\src\AS\src ^
  -output doc