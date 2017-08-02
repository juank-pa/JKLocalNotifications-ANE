package com.juankpro.ane.localnotif {
  import com.juankpro.ane.localnotif.NotificationManager;

  /**
   * A class that represents the iOS subscription options that you need to send
   * while subscribing before trying to attempt sending any notification.
   * <p>Supported OS: iOS</p>
   */
  public class LocalNotifierSubscribeOptions {
    /**
     * The notification styles the application is requesting to the operating system.
     * Values for this property can be obtained from <code>flash.notifications.NotificationStyle</code>
     * <p>Supported OS: iOS</p>
     */
    public var notificationStyles:Vector.<String> = new Vector.<String>();

    public function LocalNotifierSubscribeOptions():void { }

    /**
     * This property allows setting and getting the notification styles represented as bit flags
     * instead of a Vector of Strings. This eases the transition between the AS representation
     * and the iOS internal uint representation.
     * <p>With this notation: BADGE=1, SOUND=2, ALERT=4</p>
     * <p>Supported OS: iOS</p>
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
