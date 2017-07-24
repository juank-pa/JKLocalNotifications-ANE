package com.juankpro.ane.localnotif {
  import flash.notifications.NotificationStyle;
  import com.juankpro.ane.localnotif.NotificationManager;

  public class LocalNotifierSubscribeOptions {
    public var notificationStyles:Vector.<String> = new Vector.<String>();

    public function set notificationStyleFlags(flags:uint):void {
      notificationStyles = new Vector.<String>();
      for(var i:int = 0; i < 3; i++, flags >>= 1) {
        if(flags & 1) notificationStyles.push(NotificationManager.supportedNotificationStyles[i]);
      }
    }

    public function get notificationStyleFlags():uint {
      var flags:uint = 0;
      for each(var style:String in notificationStyles) {
        flags |= 1 << NotificationManager.supportedNotificationStyles.indexOf(style);
      }
      return flags;
    }
  }
}
