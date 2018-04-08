package com.juankpro.ane.localnotif {

  /**
   * A class that represents how a persistent local notification is to be presented to the
   * user using the NotificationManager class.
   * <p>Supported OS: Android, iOS</p>
   */
  public class Notification extends Object {
    /**
     * This constant is used as the <code>NotificationEvent.notificationAction</code>
     * for notifications that have been dismissed by the user instead of tapped.
     * To listen to dismiss actions the notification must be sent to a category that
     * has the <code>NotificationCategory.useCustomDismissAction</code> property set
     * to true.
     * <p>Only iOS 10 and higher support this feature. All versions of Android support this.</p>
     * <p>Supported OS: Android, iOS (10+)</p>
     * @see #category
     * @see com.juankpro.ane.localnotif.NotificationEvent#notificationAction
     * @see com.juankpro.ane.localnotif.NotificationCategory#useCustomDismissAction
     */
    public static const NOTIFICATION_DISMISS_ACTION:String = "_JKNotificationDismissAction_";

    /**
     * The data associated with the notification. It can be retrieved from a
     * <code>NotificationEvent</code> object.
     * <p>Supported OS: Android, iOS</p>
     * @default null
     * @see com.juankpro.ane.localnotif.NotificationEvent
     */
    public var actionData:Object = null;

    /**
     * The text associated with the notification action - it appears in two places.
     * The first is on the action button of the notification dialog that appears when a notification
     * is fired (only if the alert style is "Alerts").
     * The second is on the unlock slider when the device is locked. If left as null,
     * the iOS default string "View" will be used.
     * <p>In iOS 10 and later this property has no effect.</p>
     * <p>Supported OS: iOS</p>
     * @default null
     * @see #hasAction
     */
    public var actionLabel:String = null;

    /**
     * Specifies when a notification will alert the user. Use the constants defined
     * in <code>NotificationAlertPolicy</code>.
     * <p>Supported OS: Android</p>
     * @default NotificationAlertPolicy.EACH_NOTIFICATION
     * @see com.juankpro.ane.localnotif.NotificationAlertPolicy
     */
    public var alertPolicy:String = NotificationAlertPolicy.EACH_NOTIFICATION;

    /**
     * The body text of the notification.
     * A body is mandatory otherwise the notification might not trigger.
     * <p>Supported OS: Android, iOS</p>
     * @default value is null.
     */
    public var body:String = null;

    /**
     * Specifies if the notification is cleared from the notifications list and status bar after
     * it is selected.
     * <p>Supported OS: Android</p>
     * @default false
     */
    public var cancelOnSelect:Boolean = false;

    /**
     * Specifies if the notification has an action or not. On both OSs, if a notification's action is performed,
     * at the very least, the app will be brought to the foreground if it was in the background or
     * launched if it had been shut down. On iOS, the way to perform the action of a notification manifests itself
     * as a button on the notification dialog (only if notification style is "Alert") and in
     * the unlock slider when the device is locked. On Android, the way to perform an action is not visible,
     * it is performed by selecting the notification from the notification list (window shade).
     * <p>In iOS 10 and later this property has no effect.</p>
     * <p>Supported OS: Android, iOS</p>
     * @default true
     * @see #actionLabel
     */
    public var hasAction:Boolean = true;

    /**
     * Specifies the type of icon to display with the notification, specified by the
     * <code>NotificationIconType</code> class.
     * <p>You can also send any other file name (without the extension). For custom icons to work
     * you will need to recompile the ANE adding the custom icons to the res folder.</p>
     * <p>This icon is not only supported in Android but also required.</p>
     * <p>Supported OS: Android</p>
     * @default NotificationIconType.ALERT
     * @see com.juankpro.ane.localnotif.NotificationIconType
     */
    public var iconType:String = NotificationIconType.ALERT;

    /**
     * On Android, this will display the specified number on the notification icon that appears
     * in the status bar. On iOS, this will display as a number on the application icon's badge.
     * A value of zero or below will result in no badge displayed.
     * <p>Supported OS: Android, iOS</p>
     * @default 0
     */
    public var numberAnnotation:int = 0;

    /**
     * The notification will be placed in the "Ongoing" category of the notifications list instead of the
     * "Notifications" category and cannot be cleared with the Clear button.
     * <p>Supported OS: Android</p>
     * @default false
     */
    public var ongoing:Boolean = false;

    /**
     * Specifies if a sound will be played when the notification arrives.
     * The volume that it's played at is defined by the OS user settings.
     * <p>Android 7.0 (API level 26) no longer supports setting this property on the
     * Notification. It must be set in the channel which is represented by
     * <code>NotificationCategory</code>. Setup both to support all Android versions.</p>
     * <p>Supported OS: Android, iOS</p>
     * @default true
     * @see #soundName
     * @see com.juankpro.ane.localnotif.NotificationCategory#soundName
     */
    public var playSound:Boolean = true;

    /**
     * Specifies a sound by name that will be played when the notification arrives.
     * If <code>playSound</code> is true but <code>soundName</code> is not defined
     * then the operating system default sound is used.
     * <p>Android and iOS support different audio formats so, to make the notification
     * sound compatible with both you need to use the wav format at 8, 16 or 44KHz.</p>
     * <p>Android 7.0 (API level 26) no longer supports setting this property on the
     * Notification. It must be set in the channel which is represented by
     * <code>NotificationCategory</code>. Setup both to support all Android versions.</p>
     * <p>Supported OS: Android, iOS</p>
     * @default null
     * @see #playSound
     * @see com.juankpro.ane.localnotif.NotificationCategory#soundName
     */
    public var soundName:String = null;

    /**
     * The text that is displayed in the status bar when the notification first arrives.
     * <p>Supported OS: Android</p>
     * @default null
     */
    public var tickerText:String = null;

    /**
     * The title of the notification. On iOS devices, the title will only be visible at
     * the notification center entry.
     * <p>On iOS 10 and later, the title also appears in the notification banner itself even
       when the device is locked.</p>
     * <p>Supported OS: iOS, Android</p>
     * @default null
     */
    public var title:String = null;

    /**
     * Specifies if the device should vibrate when a notification arrives.
     * <p>Android 7.0 (API level 26) no longer supports setting this property on the
     * Notification. It must be set in the channel which is represented by
     * <code>NotificationCategory</code>. Setup both to support all Android versions.</p>
     * <p>Supported OS: Android</p>
     * @default true
     * @see com.juankpro.ane.localnotif.NotificationCategory#shouldVibrate
     */
    public var vibrate:Boolean = true;

    /**
     * The date and time when the system should deliver the notification.
     * <p>Supported OS: Android, iOS</p>
     * @default null
     */
    public var fireDate:Date;

    /**
     * Determines whether the notification triggers at the exact time or not.
     * If <code>isExact</code> is false then the notification will be batched with other alarms
     * to minimize battery use, otherwise the notification will trigger at the exact time.
     * <p>Notifications will always be exact prior to Android 4.4 (API level 19). Exact
     * notifications might still be affected by the Android 6.0 doze mode.</p>
     * <p>Supported OS: Android</p>
     * @default false
     * @see #allowWhileIdle
     */
    public var isExact:Boolean = false;

    /**
     * Allows triggering the notification even when the device is in idle (a.k.a doze) mode.
     * <p>Since Android 6.0 (API level 23), whenever a device is left idle for certain amount of time
     * then it will enter in doze mode. In this mode, background processes are allowed to be executed
     * only at specific operating system controlled intervals.</p>
     * <p>If it is critical for your application to deliver notifications even after the device
     * enters doze mode (e.g. a medical application), set this property to true. Use only when
     * absolutely necessary.</p>
     * <p>This property doesn't affect devices with Android systems prior to 6.0 and notifications
     * will always trigger even while idle.</p>
     * <p>Supported OS: Android</p>
     * @default false
     * @see #isExact
     */
    public var allowWhileIdle:Boolean = false;

    /**
     * The calendar interval at which to reschedule the notification.
     * If you assign a calendar unit the system reschedules the notification for
     * delivery at the specified interval.
     * <p>Use the constants defined on <code>NotificationTimeInterval</code> or
     * zero if you want the notification to trigger only once.</p>
     * <p>Supported OS: Android, iOS</p>
     * @default 0 which means don't repeat
     * @see com.juankpro.ane.localnotif.NotificationTimeInterval
     */
    public var repeatInterval:uint = 0;

    /**
     * The image to use when launching the application. This image will replace
     * the default launch image used while launching the app normally.
     * <p>This represents the base name of the image so, many images can be
     * provided following the <a href="https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Articles/iPhoneOSKeys.html#//apple_ref/doc/uid/TP40009252-SW24" target="_blank">iOS naming convention</a>
     * for default images</p>
     * <p>Supported OS: iOS</p>
     * @default null
     */
    public var launchImage:String = null;

    /**
     * Determines the amount of presence given to the notification on Android devices.
     * Lower priority levels might not sound or vibrate while high priority levels can
     * even show a heads-up notification.
     * <p>For a detail on priority levels see <code>NotificationPriority</code>.</p>
     * <p>Heads-up notifications are only available since Android 5.0 (API level 21).</p>
     * <p>Android 7.0 (API level 26) no longer supports setting this property on the
     * Notification. It must be set in the channel which is represented by
     * <code>NotificationCategory</code>. Setup both to support all Android versions.</p>
     * <p>Supported OS: Android</p>
     * @default NotificationPriority.DEFAULT
     * @see com.juankpro.ane.localnotif.NotificationPriority
     * @see com.juankpro.ane.localnotif.NotificationCategory#importance
     */
    public var priority:int = NotificationPriority.DEFAULT;

    /**
     * If <code>true</code> it allows the notification to appear in the foreground in
     * addition to the background. This will make the notification not to trigger anything
     * in the application unless the user taps the notification.
     * <p>This feature is only available for iOS 10 and later, and all Android versions
     * supported by the ANE.</p>
     * <p>Supported OS: Android, iOS</p>
     * @default false
     */
    public var showInForeground:Boolean = false;

    /**
     * Defines the id of the category to associate with this notification. This category
     * defines the action buttons the notification will show to the user.
     * <p>Categories must be registered using <code>NotificationManager.subscribe</code></p>
     * <p>On Android this property will have a default value of <code>"_DefaultCategory"</code>
     * to support Android 7.0 (API level 26) channels.
     * See <code>NotificationManager.setupDefaultCategory</code>.</p>
     * <p>Supported OS: Android, iOS</p>
     * @see com.juankpro.ane.localnotif.NotificationManager#subscribe
     * @see com.juankpro.ane.localnotif.NotificationManager#setupDefaultCategory
     * @see com.juankpro.ane.localnotif.NotificationCategory
     */
    public var category:String;

    public function Notification():void {
        CONFIG::android {
            category = "_DefaultCategory";
        }
    }
  }
}
