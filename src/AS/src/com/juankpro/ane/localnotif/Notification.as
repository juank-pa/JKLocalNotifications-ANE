package com.juankpro.ane.localnotif {

  /**
   * A class that represents how a persistent local notification is to be presented to the
   * user using the NotificationManager class.
   * <p>Supported OS: Android, iOS</p>
   */
  public class Notification extends Object {
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
     * is fired (only if alert syle is "Alerts").
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
    public var alertPolicy:String;

    /**
     * The body text of the notification.
     * <p>Supported OS: Android, iOS</p>
     * @default value is null.
     */
    public var body:String = null;

    /**
     * Specifies if the notification is cleared from the notifications list and status bar after
     * it is selected.
     * <p>Supported OS: Android</p>
     * @default true
     */
    public var cancelOnSelect:Boolean = false;

    /**
     * Specifies if the notification has an action or not. On both OSs, if a notification's action is performed,
     * at the very least, the app will be brought to the foreground if it was in the background or
     * launched if it had been shutdown. On iOS, the way to perform the action of a notification manifests itself
     * as a button on the notification dialog (only if alert style is "Alerts") and in
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
     * <p>Supported OS: Android</p>
     * @default NotificationIconType.ALERT
     * @see com.juankpro.ane.localnotif.NotificationIconType
     */
    public var iconType:String;

    /**
     * On Android this will display the specified number on the notification icon that appears
     * in the status bar. On iOS this will display as a number on the application icon's badge.
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
     * The volume that it's played at are defined by the user settings on the OS.
     * <p>Supported OS: Android, iOS</p>
     * @default true
     * @see #soundName
     */
    public var playSound:Boolean = true;

    /**
     * Specifies a sound by name that will be played when the notification arrives.
     * If <code>playSound</code> is true but <code>soundName</code> is not defined
     * then the operating system default sound is used.
     * <p>Supported OS: iOS</p>
     * @default true
     * @see #playSound
     */
    public var soundName:String = null;

    /**
     * The alert (sound and vibration) of a notification will be repeated until it is canceled
     * or the notifications list is opened.
     * <p>Supported OS: Android</p>
     * @default false
     */
    public var repeatAlertUntilAcknowledged:Boolean = false;

    /**
     * The text that is displayed in the status bar when the notification first arrives.
     * <p>Supported OS: Android</p>
     * @default null
     */
    public var tickerText:String = null;

    /**
     * The title of the notification. On iOS devices the title will only be visible at
     * the notification center entry.
     * <p>In iOS 10 and later the title also appears in the notification banner itself even when the device is locked.</p>
     * <p>Supported OS: iOS, Android</p>
     * @default null
     */
    public var title:String = null;

    /**
     * Specifies if the device should vibrate when a notification arrives.
     * <p>Supported OS: Android</p>
     * @default true
     */
    public var vibrate:Boolean = true;

    /**
     * The date and time when the system should deliver the notification.
     * <p>Supported OS: iOS, Android</p>
     * @default null
     */
    public var fireDate:Date;

    /**
     * The calendar interval at which to reschedule the notification.
     * If you assign a calendar unit the system reschedules the notification for
     * delivery at the specified interval.
     * <p>Use the constants defined on <code>NotificationTimeInterval</code> or
     * zero if you want the notification to trigger only once.</p>
     * <p>Supported OS: iOS, Android</p>
     * @default 0 which means don't repeat
     * @see com.juankpro.ane.localnotif.NotificationTimeInterval
     */
    public var repeatInterval:uint = 0;

    /**
     * Initializes the notification.
     * <p>Supported OS: Android, iOS</p>
     */
    public function Notification() {
      alertPolicy = NotificationAlertPolicy.EACH_NOTIFICATION;
      iconType = NotificationIconType.ALERT;
    }
  }
}
