package com.juankpro.ane.localnotif {
  /**
   * This class represents an action button for the notification.
   * <p>All actions must be part of a category that must be registered at application
   * startup using <code>NotificationManager.subscribe</code>.</p>
   * <p>Supported OS: Android, iOS</p>
   * @see com.juankpro.ane.localnotif.NotificationManager#subscribe()
   */
  public class NotificationAction extends Object {
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
     * <p>This icon is not only supported on Android but also mandatory.</p>
     * <p>Supported OS: Android</p>
     * @default NotificationIconType.ALERT
     * @see com.juankpro.ane.localnotif.NotificationIconType
     */
    public var icon:String = NotificationIconType.ALERT;

    /**
     * Determines whether the action will open the application and bring it to the front or if
     * it will just leave it in the background. In both cases the <code>NotificationEvent.NOTIFICATION_ACTION</code>
     * will still trigger.
     * <p>Supported OS: Android, iOS</p>
     * @default false
     */
    public var isBackground:Boolean = false;
  }
}
