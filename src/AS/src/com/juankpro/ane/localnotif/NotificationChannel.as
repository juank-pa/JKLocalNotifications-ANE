package com.juankpro.ane.localnotif {
  /**
   * A class that represents the notification channel required for Android API level 26 (Oreo) devices.
   * to send notifications.
   * <p>Android  Android API level 26 (Oreo) devices and later requires creating a notification channel before the
   * notifications can begin working. This channel centralizes the <code>vibrationEnabled</code>
   * (translates to <code>Notification.vibrate</code>), and <code>importance</code> (controls
   * notification visual presence and sound) properties.</p>
   * <p>To support the complete range of Android
   * devices you need to set the <code>Notification.vibrate</code> and
   * <code>Notification.hasSound</code> properties as well as create an instance of a
   * <code>NotificationChannel</code> set its properties and register it with
   * <code>NotificationManger.createNotificationChannel</code>.</p>
   * <p>Supported OS: Android</p>
   * @see com.juankpro.ane.localnotif.Notification#playSound
   * @see com.juankpro.ane.localnotif.Notification#vibrate
   * @see com.juankpro.ane.localnotif.NotificationManager#createNotificationChannel()
   * @see com.juankpro.ane.localnotif.NotificationManager#deleteNotificationChannel()
   */
  public class NotificationChannel {
    private var _id:String;

    /**
     * The channel id. It must be unique in the application namespace. If you create
     * a channel with the same id of an existing channel you will update it.
     * <p>Once you register the channel with <code>NotificationManager.createNotificationChannel</code>
     * only the name and description can be updated. All other properties will remain unchanged.</p>
     * <p>Supported OS: Android</p>
     * @see com.juankpro.ane.localnotif.NotificationManager#createNotificationChannel()
     */
    public function get id():String {
      return _id;
    }

    /**
     * The name assigned to the channel. This name is shown in the notification settings.
     * <p>This property can be updated even after the channel has been created.</p>
     * <p>Supported OS: Android</p>
     */
    public var name:String;

    /**
     * The description assigned to the channel. This description is shown in the notification settings.
     * <p>This property can be updated even after the channel has been created.</p>
     * <p>Supported OS: Android</p>
     */
    public var description:String;

    /**
     * Determines if the notifications sent trough this channel will vibrate.
     * <p>This property replaces the <code>Notification.vibrate</code> property on
     * Android API level 26 (Oreo) and later devices. To support the whole range of Android
     * devices use both.</p>
     * <p>Once the channel is created you will not be able to update this property.</p>
     * <p>Supported OS: Android</p>
     * @see com.juankpro.ane.localnotif.Notification#vibrate
     */
    public var vibrationEnabled:Boolean = false;

    /**
     * Sets the presence of the notifications sent through this channel. To set this property
     * use the constants defined in <code>NotificationImportance</code>.
     * <p>Depending on the importance level you can control whether a heads-up or sound are added
     * to the notification, and the places it appears.</p>
     * <p>This property replaces indirectly the <code>Notification.hasSound</code> property on
     * Android API level 26 (Oreo) and later devices. To support the whole range of Android
     * devices use both.</p>
     * <p>Once the channel is created you will not be able to update this property.</p>
     * <p>Supported OS: Android</p>
     * @see com.juankpro.ane.localnotif.NotificationImportance
     * @see com.juankpro.ane.localnotif.Notification#playSound
     */
    public var importance:int = NotificationImportance.DEFAULT;

    /**
     * Initializes the notification channel.
     * <p>Supported OS: Android</p>
     * @param id The unique id that identifies the channel.
     * @param name The name assigned to the channel.
     * @param importance The channel importance.
     * @see #id
     * @see #name
     * @see #importance
     * @see com.juankpro.ane.localnotif.NotificationImportance
     */
    public function NotificationChannel(id:String, name:String, importance:int) {
      _id = id;
      this.name = name;
      this.importance = importance;
    }
  }
}
