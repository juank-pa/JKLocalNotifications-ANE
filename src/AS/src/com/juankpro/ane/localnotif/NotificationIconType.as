package com.juankpro.ane.localnotif {
	/**
	 * A class of constants representing the different icon types available to use with the
     * <code>iconType</code> property of the Notification class.
	 * <p>Supported OS: Android</p>
	 */
    final public class NotificationIconType {
        /**
         * Alert icon.
         */
        public static const ALERT:String = "ic_stat_notify_ln_alert";
        /**
         * Document icon.
         */
        public static const DOCUMENT:String = "ic_stat_notify_ln_document";
        /**
         * Error icon.
         */
        public static const ERROR:String = "ic_stat_notify_ln_error";
        /**
         * Flag icon.
         */
        public static const FLAG:String = "ic_stat_notify_ln_flag";
        /**
         * Info icon.
         */
        public static const INFO:String = "ic_stat_notify_ln_info";
        /**
         * Message icon.
         */
        public static const MESSAGE:String = "ic_stat_notify_ln_message";

        /**
         * @private
         */
        public function NotificationIconType() {
            throw new Error("Cannot create an instance of this class");
        }
    }
}
