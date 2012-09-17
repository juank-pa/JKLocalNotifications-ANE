# path to YOUR Android SDK
export AIR_ANDROID_SDK_HOME="/Users/juancarlos/android-sdk-macosx"

# path to the ADT tool in Flash Builder sdks
ACOMPC="/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin/acompc"

# path to the ADT tool in Flash Builder sdks
ADT="/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin/adt"

# native Android project folder
NATIVE_ANDROID_FOLDER=../src/Eclipse

# native XCode project folder
NATIVE_XCODE_FOLDER=../src/XCode/LocalNotificationLib

# AS lib folder
LIB_FOLDER=../src/FlashBuilder

# name of ANE file
ANE_NAME=LocalNotificationLib

# JAR filename
JAR_NAME=localnotification.jar

#===================================================================

echo "****** ANDROID VERSION *******"
echo "****** preparing ANE Android package sources *******"

rm ${ANE_NAME}.*
rm -rf ./android
mkdir -p ./android
mkdir -p ./android/res

# copy resources
cp -R ./${NATIVE_ANDROID_FOLDER}/res ./android

# create JAR file
cp ./${NATIVE_ANDROID_FOLDER}/bin/eclipse.jar ./android/${JAR_NAME}
#jar cf ./build/ane/Android-ARM/${JAR_NAME} -C ./${NATIVE_ANDROID_FOLDER}/bin .

# compile Android SWC version
"$ACOMPC" -locale en_US \
    -swf-version 14 \
    -define+=CONFIG::device,true \
    -define+=CONFIG::iphone,false \
    -define+=CONFIG::android,true \
    -source-path ./${LIB_FOLDER}/src/ \
    -output ./${ANE_NAME}.swc \
    -include-sources ./${LIB_FOLDER}/src/

# grab SWC library
unzip ./*.swc -d .
mv ./library.swf ./android
rm ./catalog.xml

echo "****** END ANDROID VERSION *******"
echo ""

echo "****** IOS VERSION *******"
echo "****** preparing ANE iOS package sources *******"

rm ${ANE_NAME}.*
rm -rf ./iphone
mkdir -p ./iphone

# copy A file
cp ./${NATIVE_XCODE_FOLDER}/Release/libLocalNotificationLib.a ./iphone/

# compile iOS SWC version
"$ACOMPC" -locale en_US \
    -swf-version 14 \
    -define+=CONFIG::device,true \
    -define+=CONFIG::iphone,true \
    -define+=CONFIG::android,false \
    -source-path ./${LIB_FOLDER}/src/ \
    -output ./${ANE_NAME}.swc \
    -include-sources ./${LIB_FOLDER}/src/

# grab SWC library
unzip ./*.swc -d .
mv ./library.swf ./iphone
rm ./catalog.xml

echo "****** END IOS VERSION *******"
echo ""

echo "****** DEFAULT VERSION *******"
echo "****** preparing ANE default package sources *******"

rm ${ANE_NAME}.*
rm -rf ./default
mkdir -p ./default

# compile Default SWC version
"$ACOMPC" -locale en_US \
    -swf-version 14 \
    -define+=CONFIG::device,false \
    -define+=CONFIG::iphone,false \
    -define+=CONFIG::android,false \
    -source-path ./${LIB_FOLDER}/src/ \
    -output ./${ANE_NAME}.swc \
    -include-sources ./${LIB_FOLDER}/src/

# grab SWC library
unzip ./*.swc -d .
mv ./library.swf ./default
rm ./catalog.xml

echo "****** END DEFAULT VERSION *******"
echo ""

echo "****** creating ANE package *******"

"$ADT" -package \
    -target ane \
    ./${ANE_NAME}.ane \
    ./extension.xml \
    -swc ./*.swc \
    -platform Android-ARM \
    -C ./android/ . \
    -platform iPhone-ARM \
    -C ./iphone/ . \
    -platformoptions ./options.xml \
    -platform default \
    -C ./default/ library.swf

echo "****** ANE package created *******"
echo ""

