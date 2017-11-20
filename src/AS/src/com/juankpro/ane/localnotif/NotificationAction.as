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
     * The action button title. It defines the label to use for the button.
     * <p>Supported OS: Android, iOS</p>
     */
    public var title:String;

    /**
     * Constructor
     */
    public function NotificationAction() { }
  }
}
