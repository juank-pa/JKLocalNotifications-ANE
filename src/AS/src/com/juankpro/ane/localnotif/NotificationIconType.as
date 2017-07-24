package com.juankpro.ane.localnotif {
	/**
	 * A class of constants representing the different icon types available to use with the iconType property of the Notification class.
	 * <p>Supported OS: Android</p>
	 */
    final public class NotificationIconType {
        public static const ALERT:String = "alert";
        public static const DOCUMENT:String = "document";
        public static const ERROR:String = "error";
        public static const FLAG:String = "flag";
        public static const INFO:String = "info";
        public static const MESSAGE:String = "message";

        public function NotificationIconType() {
            throw new Error("Cannot create an instance of this class");
        }
    }
}
