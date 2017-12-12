package com.juankpro.ane.localnotif {
  /**
   * This class represents an action button for the notification.
   * <p>All actions must be part of a category that must be registered at application
   * startup using <code>NotificationManager.subscribe</code>.</p>
   * <p>Supported OS: Android, iOS</p>
   * @see com.juankpro.ane.localnotif.NotificationManager#subscribe()
   */
  final public class NotificationAction extends Object {
    /**
     * The action identifier.
     * <p>This identifier will be sent to the <code>Event.NOTIFICATION_ACTION</code> event
     * so you can recognize which action was selected.</p>
     * <p>Supported OS: Android, iOS</p>
     * @see com.juankpro.ane.localnotif.NotificationEvent
     */
    public var identifier:String;

    /**
     * The action button title. It defines the label for the button.
     * <p>Supported OS: Android, iOS</p>
     */
    public var title:String;
    
    /**
     * Specifies the type of icon to display for the notification action, specified by the
     * <code>NotificationIconType</code> class constants.
     * <p>You can also send any other file name (without the extension). For custom icons to work
     * you will need to recompile the ANE adding the custom icons to the res folder.</p>
     * <p>This icon is not only supported in Android but also required.</p>
     * <p>Supported OS: Android</p>
     * @default NotificationIconType.ALERT
     * @see com.juankpro.ane.localnotif.NotificationIconType
     */
    public var icon:String = NotificationIconType.ALERT;

    /**
     * Determines whether the action will open the application and bring it to the front or if
     * it will just leave it in the background. In both cases the <code>NotificationEvent.NOTIFICATION_ACTION</code>
     * will still trigger.
     * <p>This feature is disabled by default on Android devices because the OS can only support
     * this partially. If the application is in the background then it will stay in the background
     * when the action is triggered but if the application was not running, either because the user closed it
     * or the operating system shut it down, then there is no way to make the application stay
     * in the background when opening it due to the lack of access to the Activity managed by AIR
     * at application creation time.</p>
     * <p>If you are OK with this limitation you can force background actions in Android by calling
     * the <code>LocalNotifierSubscribeOptions.allowAndroidBackgroundNotificationActions</code> method.</p>
     * <p>Supported OS: Android(partially), iOS</p>
     * @default false
     * @see com.juankpro.ane.localnotif.LocalNotifierSubscribeOptions#allowAndroidBackgroundNotificationActions
     */
    public var isBackground:Boolean = false;

    /**
     * Constructor
     */
    public function NotificationAction() { }
  }
}
