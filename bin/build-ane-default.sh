# path to YOUR Android SDK
export AIR_ANDROID_SDK_HOME="/Users/juancarlos/android-sdk-macosx"

# path to the ADT tool in Flash Builder sdks
ACOMPC="/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin/acompc"

# path to the ADT tool in Flash Builder sdks
ADT="/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin/adt"

# AS lib folder
LIB_FOLDER=../src/FlashBuilder

# name of ANE file
ANE_NAME=LocalNotificationLib

#===================================================================

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
echo "****** END DEFAULT VERSION *******"
echo ""

