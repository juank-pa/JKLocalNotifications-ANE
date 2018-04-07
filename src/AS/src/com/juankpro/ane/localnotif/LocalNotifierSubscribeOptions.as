package com.juankpro.ane.localnotif {
  import com.juankpro.ane.localnotif.NotificationManager;

  /**
   * A class that represents the iOS subscription options that you need to send
   * while subscribing before trying to attempt sending any notification.
   * Android devices need a subscription only if they intend to use custom action
   * buttons in the notification, but there is no harm in subscribing for notifications
   * even if this is not the case because Android OS will always dispatch the
   * <code>Event.SETTINGS_SUBSCRIBED</code> event successfully.
   * <p>Supported OS: Android, iOS</p>
   * @see com.juankpro.ane.localnotif.NotificationManager#subscribe()
   */
  public class LocalNotifierSubscribeOptions {
    /**
     * The notification styles the application is requesting to the operating system.
     * Values for this property can be obtained from <code>flash.notifications.NotificationStyle</code>.
     * <p>Supported OS: Android, iOS</p>
     */
    public var notificationStyles:Vector.<String> = new Vector.<String>();
    /**
     * A list of categories to register. A category defines the action buttons to show
     * for Notifications related to the category.
     * <p>Once registered a notification should set <code>Notification.category</code> to
     * the id of an existing category to show the custom actions defined for it.</p>
     * <p>Supported OS: Android, iOS</p>
     * @see com.juankpro.ane.localnotif.NotificationManager#subscribe
     * @see com.juankpro.ane.localnotif.Notification#category
     */
    public var categories:Vector.<NotificationCategory>;

    /**
     * Constructor.
     * @param categories The categories to register along with their respective actions.
     *                   Categories are only needed if you want to show custom action buttons in the
     *                   notification, otherwise, you can omit this parameter.
     */
    public function LocalNotifierSubscribeOptions(categories:Vector.<NotificationCategory> = null):void {
      this.categories = categories || new Vector.<NotificationCategory>();
    }

    /**
     * This property allows setting and getting the notification styles represented as bit flags
     * instead of a Vector of Strings. This eases the transition between the AS representation
     * and the mobile devices native uint representation.
     * <p>With this notation: BADGE=1, SOUND=2, ALERT=4</p>
     * <p>Supported OS: Android, iOS</p>
     */
    public function set notificationStyleFlags(flags:uint):void {
      notificationStyles = new Vector.<String>();
      for(var i:int = 0; i < 3; i++, flags >>= 1) {
        if(flags & 1) notificationStyles.push(NotificationManager.supportedNotificationStyles[i]);
      }
    }

    /**
     * @private
     */
    public function get notificationStyleFlags():uint {
      var flags:uint = 0;
      for each(var style:String in notificationStyles) {
        flags |= 1 << NotificationManager.supportedNotificationStyles.indexOf(style);
      }
      return flags;
    }
  }
}
