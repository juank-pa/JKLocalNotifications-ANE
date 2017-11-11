# JKLocalNotifications ANE

[![Build Status](https://travis-ci.org/juank-pa/JKLocalNotifications-ANE.svg?branch=master)](https://travis-ci.org/juank-pa/JKLocalNotifications-ANE)

This is a Native Extension based on the one exposed by
[Daniel Koestler](http://blogs.adobe.com/koestler/). It fixes some issues
and adds some other capabilities to the iOS side, like the ability to re-schedule
local notifications in the future and the ability to update the application
badge number at will.

This LocalNotification ANE repository contains many different components:
- The Java source code to allow notifications on Android devices (src/AndroidStudio).
- The Objective-C source code to allow notifications on iOS devices (src/XCode).
- The AS3 source code to bridge between ActionScript and the native libraries (src/AS).
- Shell files that allow building native code into an ANE file (bin).
- A sample application that allows testing the ANE (samples).

We'll explain all of these components one by one but first let's go over the requirements.

# Requirements
* The project requires the AIR SDK 26 or greater which ca be downloaded
[here](http://www.adobe.com/devnet/air/air-sdk-download.html). Even though you can place
the SDK anywhere in your computer, all the shell scripts expect to find it at
`$HOME/Developer/AIR_SDK` so it will be a good idea to place it there. If you still
decide to place the SDK somewhere else please update the corresponding shell files.
* XCode 8.2.1 or greater with support for iOS 8.4 or greater.
* Android Studio for the Android native code.

# The Objective-C source code
This is basically an XCode project placed at the `src/XCode` directory.
The project contains three targets:

1. The `LocalNotificationLib` target is the library for the ANE itself.
You can build this target into an `.a` library needed for the ANE.
2. The `LocalNotificationTests` is a Unit Test target that you can run to
verify everything is working as expected. Write your own test here at will.
Mocking is powered by [OCMock](http://ocmock.org/).
3. The `LocalNotificationSample` project is a simple native application to test
the library functionality.

The Objective-C project was ported to ARC architecture to simplify code
and prevent memory leaks.

## Building the library
To test your AIR application using the iOS simulator, build the library while having
one of the iOS simulator devices selected in XCode. `Debug` builds are fine.

To generate the final version for real devices, build the library while having
a real device selected in XCode. You can compile the library for `Debug` or `Release`
but it is highly recommended to build it for `Release` for performance reasons.

The resulting `.a` library will be placed inside `src/XCode/LocalNotificationLib/Debug`
or `src/XCode/LocalNotificationLib/Release` depending on the configuration.

## UILocalNotification vs. UNUserNotificationCenter
This ANE uses the new `UNUserNotificationCenter` notifications API for iOS 10
and later, while still using `UILocalNotification` for iOS 8-9. The idea behind
this was to start supporting the new `UNUserNotificationCenter` features in the
near future and ease the transition when `UILocalNotification` was no longer
available.

Right now both implementations do the exact same thing but soon newer
ANE versions will migrate completely to the new API to support even more
features, while dropping support for iOS 9 and prior.

# The Android source code
This is an Android Studio project placed at the `src/AndroidStudio` folder.
Thanks to all of the ANE supporters I have found the desire to start learning Android
a bit more and have started to revamp the otherwise completely outdated Android project.
This project supports Android SDK 16 (4.1 - Jelly Bean) and later.

You need to compile the project to generate the expected files to build the ANE.
Additionally the project contains icons in the resource folder `res` which are copied
to the final ANE to allow the Java version to set an icon for the notification.
Edit the icons in this project if you want to customize them.

## Adding Android custom icons HACK
There is a way to add custom icons to the Android notifications but only through a hack.
Referencing a packaged bitmap directly is possible only on Android API level 24 (Nougat) and later.
This will have forced the ANE to support level 24 and later versions and I'm always trying to
support 95-99% of the currently existing devices.

The hack needs the developer to re-compile the ANE through the following procedure:

1. Add a `res` folder under the `bin` folder.
2. Place all additional resources there using the same structure as required for Android projects.
3. Compile the ANE using one of the build shell scripts.
4. In your AS3 application code set the `Notification.iconType` to the name of the file without
   including the file extension.
5. Compile your application normally.

**Note:** You can actually simply open the ANE file with a compression app e.g. 7zip
and modify or add icons at will. Thanks to [@subdan](https://github.com/subdan)
for pointing this out.

# The ActionScript 3.0 source code

This is the AS3 source code of the ANE itself placed at the `src/AS` folder.
The code is pretty straight forward. When compiling the ANE, three compiler defines
allow conditional compilation for different targets:

1. *`CONFIG::device`:* Code inside this block is compiled only for mobile devices.
The `default` version used for testing the notifications locally in a computer does not
compile them to prevent run-time errors where notifications are not supported.
2. *`CONFIG::iphone`:* Code inside this block is compiled only for iPhone devices.
This block must always be nested inside a `CONFIG::device` block.
3. *`CONFIG::android`:* Code inside this block is compiled only for Android devices.
This block must always be nested inside a `CONFIG::device` block.

## Testing the ActionScript code
The source code comes with a test suite at the `src/AS/tests` folder and are supported by
`ASUnit` and `Mock4AS`.

### Adding new tests
To add additional tests place them inside the `src/AS/tests/src` folder.
The test class must inherit `asunit.framework.TestCase` and test methods must start with
the `test` prefix.

Once you create your test class, add it to the test suite `src/AS/tests/src/AllTests.as`.
There is a static test `Array` at the top of this file listing the test classes.

### Running tests
To run tests, cd to the `src/AS` folder and execute:
```bash
./runtests
```
The only requirement is to have the AIR SDK installed in the expected folder.
See [Requirements](#requirements).

# The ANE compilation shell scripts
There are a bunch of shell scripts with code to automatize the ANE compilation process.
The scripts are placed at the `bin` folder.

To compile the ANE:
1. First ensure that you have compiled the iOS and Android source codes for
the desired device target. I might try to automatize the library compilation in the
future but for now you need to do this manually.
2. Change directory to `bin`.
3. If necessary update the `bin/config.sh` file to adjust your AIR SDK path and version.
You might also need to adjust the XCode `CONFIGURATION` to match the configuration you used
to compile the XCode `.a` library (`Debug` or `Release`).
4. You can now run any of the scripts depending on which kind of ANE you need.

## A shell script for every need
You have many different shell scripts depending on what you need:

* To compile the final ANE for production including all supported device libraries use:
  ```bash
  ./build-ane
  ```
* If you want to just test you Android or iOS implementation without needing to compile
other targets then use the `build-ane-ios` or `build-ane-android` scripts. These scripts
will compile only the specific target assets and will be suitable for testing
but not for production:
  ```bash
  ./build-ane-ios
  # or
  ./build-ane-android
  ```
* If you want to compile a version of the ANE suitable for the iOS simulator use:
  ```bash
  ./build-ane-ios-simulator
  ```
  Please modify the `CONFIGURATION` to match the configuration used to compile
  the `.a` library.

Intermediate files will be placed inside the `bin/tmp` folder while the resulting
ANE will be placed at `bin/ext`, you can then use this ANE file to compile the
repository provided samples or for your own projects.

### Windows command line scripts
I'm planning to create .bat files for Windows to replicate the build shell scripts
into this OS as well.

Right now only the build `bin/build-ane-android.bat` and `bin/build-ane-android-simulator`
scripts are implemented, as well as the `samples/plain_as/run-android-app.bat` and
`samples/plain_as/run-android-emulator-app.bat` scripts to allow packaging and installing
the sample application into Android emulator or real devices.

These batch scripts depend on the 7zip `7za` command line application, so you might need to
download it and place it in your PATH.

## Samples
Originally I placed a FlashBuilder sample as well as a Flash Professional one
(now Animate). Because I am now a huge fan of command-line workflows I no longer
support these editors. I left the samples in there but further support for them
will definitively will depend on collaborators.

The only supported sample right now is the one at `samples/plain_as`. This is a
command-line based simple project. The sample contains a single `Sample.as` file
a custom sound `fx05.caf` and some shell scripts.

The sample will show buttons for sending a notification and cancelling it, as well
as a simple console to print results.

Use the different scripts to compile your desired application:

* To build and install an iOS IPA file use:
  ```bash
  ./run-ios-app
  ```
  You need to customize `CERT_FILE`, `CERT_PASS`, and `PROVISIONING_PROFILE` variables
  to match your own certicate and provisioning profile information.

  Installation of the final application is not working at the time so once the IPA
  is packaged you might want to install it manually via XCode Devices panel or iTunes.
* To build and install an iOS simulator IPA file:
  ```bash
  ./run-ios-simulator-app
  ```
  Customize the `AIR_IOS_SIMULATOR_DEVICE` variable to match the simulator you want to
  select for installation and execution.
  To query a list of simulator devices in your system use:
  ```bash
  xcrun simctl list devices
  ```

  You must also customize the `IPHONE_SDK` path. To determine the path to your SDK use:
  ```bash
  xcrun --sdk iphonesimulator --show-sdk-path
  ```
* To build and install an Android emulator APK file:
  ```bash
  ./run-android-emulator-app
  ```
* And finally, to build and install an Android device APK file:
  ```bash
  ./run-android-app
  ```

**NOTE:** The run shell scripts for Android not only compile and package the project but also
they re-compile the ANE because the Sample uses a custom icon and this forces the re-compilation.
These scripts add the resources at `samples/plain_as/res` to the generated ANE extension.
More information [here](#adding-android-custom-icons-hack).

# ANE distribution
If what you want is simply get the latest version of the ANE and use it in your own
project you can download the latest compiled version from the
[Releases](https://github.com/juank-pa/JKLocalNotifications-ANE/releases) page.
Just grab it and use it. Use the samples provided to learn a bit more.

# Documentation
The AS3 classes are well documented by using comments. But if you need a user friendly
documentation you can run the following command while at the root path:
```bash
./build-doc
```
This will create a doc folder at the root path on this repo with an HTML version of the
documentation. Open the `index.html` file to read it.
This command needs the AIR SDK installed in the expected folder. See [Requirements](#requirements).
