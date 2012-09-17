# path to YOUR Android SDK
export AIR_ANDROID_SDK_HOME="/Users/juancarlos/android-sdk-macosx"

# path to the ADT tool in Flash Builder sdks
ACOMPC="/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin/acompc"

# path to the ADT tool in Flash Builder sdks
ADT="/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin/adt"

# native Android project folder
NATIVE_ANDROID_FOLDER=../src/Eclipse

# AS lib folder
LIB_FOLDER=../src/FlashBuilder

# name of ANE file
ANE_NAME=LocalNotificationLib

# JAR filename
JAR_NAME=localnotification.jar

#===================================================================

echo "****** ANDROID VERSION *******"
echo "****** preparing ANE package sources *******"

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
echo "****** END ANDROID VERSION *******"
echo ""

