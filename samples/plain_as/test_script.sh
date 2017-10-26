cd ../../bin/ext
unzip LocalNotificationLib.ane -d LocalNotificationLib
cp -rf ../../samples/plain_as/res LocalNotificationLib/META-INF/ANE/Android-ARM/
mkdir LocalNotificationLib/META-INF/ANE/Android-ARM/res/raw
cp ../../samples/plain_as/fx05.caf LocalNotificationLib/META-INF/ANE/Android-ARM/res/raw/
rm -f LocalNotificationLib.ane
zip -r LocalNotificationLib.ane LocalNotificationLib/*
rm -rf LocalNotificationLib/
cd ../../samples/plain_as
