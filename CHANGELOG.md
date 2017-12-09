### Version 1.1.0
* You can now use a custom sound for notifications in Android.
* Use the new `Notification.launchImage` property to replace the launch image used when the
  application is launched when a specific notification triggers.
* Allow Android packages to determine the notification priority to allow a more fine-grained
  control over the notification presence and allow showing a heads-up notification for
  Android 5.0 (API level 21) and later devices.
* Notifications can also show in the foreground. When notifications display in the foreground
  no event is dispatched.
* You add custom action buttons to notifications to perform different tasks when tapped.

### Unreleased
* Fixed a bug that prevented a notification from triggering if the app was not currently
  running and the event listener was registered after registering some other event listeners.

### Version 1.0.6
* Fixed a bug that made notification events to trigger only once During the application
  lifetime.

### Version 1.0.5
* Android notifications support large notification body texts using expanded layout.

### Version 1.0.4
* Added batch scripts to allow compiling the ANEs and running the sample application on
  Android devices on Windows.
* Refactored build scripts to prevent repetition.
* Added support for Android x86 devices.
* Fixed broken distribution ANE.

### Version 1.0.3
* Added the ability to use custom icons for Android notifications through a
  [hack](https://github.com/juank-pa/JKLocalNotifications-ANE#adding-android-custom-icons-hack).

### Version 1.0.2
* Improved and new build scripts for the Android ANE and sample application.
* The Android project was so outdated the was actually not working at all. The Android project
  has been ported from Eclipse to Android Studio and has been completely revamped to make it work
  and to use better coding practices.
* Added a test suite for the basic Android classes. Other components tests are still pending.

### Version 1.0.1
* Removed the `ERA_CALENDAR_UNIT` and `WEEKDAY_CALENDAR_UNIT` constants from `NotificationTimeInterval`
  because these intervals were never implemented in either iOS or Android. These
  constants were creating invalid notifications that were never triggering.
* Added a CHANGELOG

**iOS library**
* Added support to notifications through `UNUserNotificationCenter` for iOS 10 and later.
* Migrated the ANE to ARC to improve memory management and simplify code.

### Version 1.0
* Add notification information for Android and iOS.
* Trigger notifications at a specific date in the future.
* Re-schedule notifications at regular intervals.
* The ANE was reborn after a long sleep.
