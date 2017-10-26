package com.juankpro.ane.localnotif {
	/**
	 * A class of constants representing the different icon types available to use with the
   * <code>iconType</code> property of the Notification class.
	 * <p>Supported OS: Android</p>
	 */
    final public class NotificationIconType {
        public static const ALERT:String = "jk_localnotif_alert_icon";
        public static const DOCUMENT:String = "jk_localnotif_document_icon";
        public static const ERROR:String = "jk_localnotif_error_icon";
        public static const FLAG:String = "jk_localnotif_flag_icon";
        public static const INFO:String = "jk_localnotif_info_icon";
        public static const MESSAGE:String = "jk_localnotif_message_icon";

        /**
         * @private
         */
        public function NotificationIconType() {
            throw new Error("Cannot create an instance of this class");
        }
    }
}
