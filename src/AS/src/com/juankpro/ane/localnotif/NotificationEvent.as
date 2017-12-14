package com.juankpro.ane.localnotif {
  import flash.events.*;

  /**
   * NotificationEvent is an Event that is fired when a Notification is received
   * or when it has been subscribed.
   * <p>Supported OS: Android, iOS</p>
   */
  public class NotificationEvent extends Event {
    /**
     * The data associated with the notification using the <code>Notification.actionData</code> property.
     * <p>Supported OS: Android, iOS</p>
     * @default null
     * @see com.juankpro.ane.localnotif.Notification#actionData
     */
    public var actionData:Object = null;

    /**
     * The code of the notification given while sending the notification.
     * <p>Supported OS: Android, iOS</p>
     * @default null
     * @see com.juankpro.ane.localnotif.NotificationManager#notifyUser()
     */
    public var notificationCode:String = null;

    /**
     * The action selected by the user to trigger the notification.
     * <p>This is the <code>NotificationAction</code> identifier corresponding to the
     * selected notification action button.</p>
     * <p>If the user has pressed the notification body instead of any action button this
     * value will be null.</p>
     * <p>Supported OS: Android, iOS</p>
     * @default null
     * @see com.juankpro.ane.localnotif.NotificationAction#identifier
     */
    public var notificationAction:String = null;

    /**
     * The settings accepted by the user after subscription request.
     * Android doesn't need a subscription to send notifications, thus all notification
     * types are always accepted.
     * <p>Supported OS: Android, iOS</p>
     * @default null
     */
    public var subscribeOptions:LocalNotifierSubscribeOptions = null;

    /**
     * The NOTIFICATION_ACTION represents the notification action event type.
     * <p>The properties of the event object have the following values:</p> 
     * <table class="innertable"> 
     * <tr><th>Property</th><th>Value</th></tr>
     * <tr><td>actionData</td><td>The data sent along with the notification.</td></tr>
     * <tr><td>notificationAction</td><td>The action that was taken by the user with the notification. If the user taps the notification body this value will be null.</td></tr>
     * <tr><td>notificationCode</td><td>The code of the notification used when it was sent.</td></tr>
     * </table>
     * <p>Supported OS: Android, iOS</p>
     * @eventType notificationAction
     */
    public static const NOTIFICATION_ACTION:String = "notificationAction";

    /**
     * The SETTINGS_SUBSCRIBED constant represents the settings subscription event type.
     * <p>The properties of the event object have the following values:</p> 
     * <table class="innertable"> 
     * <tr><th>Property</th><th>Value</th></tr>
     * <tr><td>subscribeOptions</td><td>An options object with the notification types the user has accepted to receive.</td></tr> 
     * </table>
     * <p>Supported OS: Android, iOS</p>
     * @eventType settingsSubscribed
     */
    public static const SETTINGS_SUBSCRIBED:String = "settingsSubscribed";

    /**
     * Constructs a new <code>NotificationEvent</code> object with the specified parameters.
     * <p>Supported OS: Android, iOS</p>
     * @param type The event type.
     * @param code The code of the notification used when it was sent.
     * @param data The data sent along the notification.
     * @param action The action taken by the user with the notification.
     */
    public function NotificationEvent(type:String, code:String = null, data:Object = null, action:String = null) {
      super(type, true, false);
      this.notificationCode = code;
      this.actionData = data;
      this.notificationAction = action;
    }

    /**
     * @private
     */
    override public function clone() : Event {
      return new NotificationEvent(type, this.notificationCode, this.actionData, this.notificationAction);
    }

    /**
     * @private
     */
    override public function toString() : String {
      return formatToString("NotificationEvent", "type", "bubbles", "cancelable", "eventPhase", "notificationCode", "actionData", "notificationAction");
    }
  }
}
