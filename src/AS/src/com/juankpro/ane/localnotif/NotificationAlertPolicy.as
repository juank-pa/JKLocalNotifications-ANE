package com.juankpro.ane.localnotif {
  /**
   * A class of constants representing when a notification will alert the user. It is available
   * to use with the alertPolicy property of the Notification class.
   * <p>Supported OS: Android</p>
   */
  final public class NotificationAlertPolicy extends Object {
    /**
     * A notification will alert the user (play sound, vibrate, etc.) each time it is fired.
     * <p>Supported OS: Android</p>
     */
    public static const EACH_NOTIFICATION:String = "eachNotification";
    /**
     * A notification will only alert the user the first time it is fired.
     * <p>Supported OS: Android</p>
     */
    public static const FIRST_NOTIFICATION:String = "firstNotification";

    /**
     * @private
     */
    public function NotificationAlertPolicy() {
      throw new Error("Cannot create an instance of this class");
    }
  }
}
