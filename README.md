This is a Native Extension based in the one exposed by
[Daniel Koestler](http://blogs.adobe.com/koestler/) that fixes some issues
and adds some other capabilities to the iOS side like the ability to schedule
local notifications in the future and the ability to update the application
badge number at will.

This LocalNotification ANE repository contains many different components:
- The Java source code to allow notifications in Android devicesi (src/Eclipse).
- The Objective-C source code to allow notifications in iOS devices (src/XCode).
- The bridge AS3 source code to bridge between ActionScript and the devices (src/AS).
- Shell files that allow building native code into an ANE file (bin).
- A sample application to allow testing the ANE (samples).

We'll explain all of this component one by one.

# The Objective-C source code
This is basically an XCode project placed in the src/XCode directory.
You need at least XCode 8.2.1 to open the project.
The project contains three targets:

1. The `LocalNotificationLib` target is the library for the ANE itself.
You can build this target into the `.a` library needed for the ANE. If
you build it for simulator then this library will only be available for
iOS simulator projects. If you build it for a real device then you can use it
to compile the final library for the ANE.
2. The `LocalNotificationTests` is a Unit Test target that you can run to
verify everything is working as expected.
3. The `LocalNotificationSample` project is a simple native application to test
the library integration.

The Objective-C project needs to use manual memory management to interact with
AIR projects.

### About UILocalNotification:
The project uses `UILocalNotification` class to implement notifications, which is
considered deprecated. Because I do not maintain this repo regularly this might
continue like this up until it is considered obsoleted, but if there are enough
requirements for this feature I might be able to implement it or at least help
through code reviews. You are welcome to collaborate!

# The ActionScript 3.0 source code

