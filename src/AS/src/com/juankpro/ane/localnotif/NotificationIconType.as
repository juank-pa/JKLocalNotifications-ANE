package com.juankpro.ane.localnotif {
	/**
	 * A class of constants representing the different icon types available to use with the
     * <code>iconType</code> property of the Notification class.
	 * <p>Supported OS: Android</p>
	 */
    final public class NotificationIconType {
        public static const ALERT:String = "ic_stat_notify_ln_alert";
        public static const DOCUMENT:String = "ic_stat_notify_ln_document";
        public static const ERROR:String = "ic_stat_notify_ln_error";
        public static const FLAG:String = "ic_stat_notify_ln_flag";
        public static const INFO:String = "ic_stat_notify_ln_info";
        public static const MESSAGE:String = "ic_stat_notify_ln_message";

        /**
         * @private
         */
        public function NotificationIconType() {
            throw new Error("Cannot create an instance of this class");
        }
    }
}
