### Unreleased

### Version 1.5.0
* Add support for Android 8.0 (API level 26, Oreo) channels. The `NotificationCategory` now
  represents Android channels and allow creating and managing channels on Android. On Android
  Oreo the sound, importance and vibration are no longer determined by the Notification but
  on the channel. The same happens in our ANE, so please setup these properties in both places
  (`Notification` and `NotificationCategory`) to support new and old versions of the Android API.
  If you haven't setup any categories or do not need them, the ANE will create a default one
  before sending any notifications.
* Added AMR64 (armv8) and Universal applications support for iOS.
* Breaking changes:
  * NotificationCategory needs to define a name on Android. Not doing so will not break AS code
    but it will crash at runtime. If you were not creating notification categories before no
    change is needed.

### Version 1.4.1
* Fix a bug preventing custom sounds from playing on Android.

### Version 1.4.0
* Dismissing a notification also triggers a notification event with an specific action id.
* Allow exact notifications in Android. Since Android 4.4 (API level 19) batches repeating and
  non-repeating notifications to save battery power making them inexact by default. If being exact
  is a requirement of you app you can now specify this condition.
* Improved monthly and yearly repeat intervals to perform accurately. Monthly interval will always
  trigger the same day each month, while yearly intervals will always trigger the same month and
  day each year.
* Allow setting alarms that will trigger even when Android 6.0 (API level 23) enters doze mode.

### Version 1.3.0
* Fix custom sounds to prevent them triggering when notifications are disabled
  or silenced by the user. For this to work the application XML must be updated by removing the
  `PlayAudio` service and adding the `NotificationSoundProvider` content provider instead.
  See README file.

### Version 1.2.1
* Fix bug that prevented notifications from triggering when using the default sound for
  the notification i.e. `Notification.soundName` was not set.

### Version 1.2.0
* You can now use a custom sound for notifications in Android.
* Use the new `Notification.launchImage` property to replace the launch image used when the
  application is launched when a specific notification triggers.
* Allow Android packages to determine the notification priority to allow a more fine-grained
  control over the notification presence and allow showing a heads-up notification for
  Android 5.0 (API level 21) and later devices.
* Notifications can also show in the foreground. When notifications display in the foreground
  no event is dispatched.
* You add custom action buttons to notifications to perform different tasks when tapped.
* Actions can open the application in the background. You need to add `android:name="com.juankpro.ane.localnotif.Application"`
  to the Android manifest application tag in your application XML file.
* Add support for text input actions to allow the user fill in data in the notification.
* Removed support-v4 and compat library dependencies from the Android version, which greatly
  reduces the ANE footprint size (from 1.69MB to 639KB) and eases ANE integration with other ANEs.
* Added a native AndroidStudio application to allow visual tests similar to what the iOS version
  has for XCode.

### Version 1.0.7
* Add support `UNUserNotificationCenter` to allow future improvements. Behavior and interface were
  kept unchanged.
* Add the ability to use custom notification icons on Android as soon as they as bundled in the ANE
  file. For this to work you have to re-compile the any this time adding the icons as resources.
  Simply set the `Notification.iconType` to the icon file name without extension.
* Add the ability to send large text bodies to Android notifications that will show in expanded mode.
* This fixed critical bugs introduced since 1.0.1.
