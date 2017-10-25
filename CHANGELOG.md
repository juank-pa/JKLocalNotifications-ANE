### Version 1.0.2
* Improved and added new build scripts for the Android ANE ans sample application.
* The Android project was so outdated the was actully not working at all. The Android project
  has been ported from Eclipse to Android Studio and has been completely revamped to make it work
  and also to attach to better coding practices.
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
