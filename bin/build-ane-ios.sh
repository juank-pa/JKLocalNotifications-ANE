# path to YOUR Android SDK
export AIR_ANDROID_SDK_HOME="/Users/juancarlos/android-sdk-macosx"

# path to the ADT tool in Flash Builder sdks
ACOMPC="/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin/acompc"

# path to the ADT tool in Flash Builder sdks
ADT="/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin/adt"

# native XCode project folder
NATIVE_XCODE_FOLDER=../src/XCode/LocalNotificationLib

# AS lib folder
LIB_FOLDER=../src/FlashBuilder

# name of ANE file
ANE_NAME=LocalNotificationLib

#===================================================================

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
echo "****** END IOS VERSION *******"
echo ""

