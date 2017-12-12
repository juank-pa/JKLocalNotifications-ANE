package com.juankpro.ane.localnotif {
	/**
	 * A class of constants representing the amount of presence given to the notification
     * on Android devices. Use these constants for the <code>priority</code> property of
     * the <code>Notification</code> class.
	 * <p>Supported OS: Android</p>
     * @see com.juankpro.ane.localnotif.Notification#priority
	 */
    final public class NotificationPriority {
        /**
         * Highest priority, for your application's most important items that require
         * the user's prompt attention or input.
         */
        public static const MAX:int = 2;
        /**
         * Higher priority, for more important notifications or alerts.
         * The UI may choose to show these items larger, or at a different position in
         * notification lists, compared with your app's <code>PRIORITY_DEFAULT</code> items.
         * Since Android 5.0 (API level 21), this priority might show a heads-up notification.
         */
        public static const HIGH:int = 1;
        /**
         * Default notification priority. If your application does not prioritize its own notifications,
         * use this value for all notifications. Commonly you have sound and vibration.
         */
        public static const DEFAULT:int = 0;
        /**
         * Lower priority, for items that are less important. The UI may choose to show
         * these items smaller, or at a different position in the list, compared with your
         * app's <code>PRIORITY_DEFAULT</code> items. Sound and vibration might be suppressed.
         */
        public static const LOW:int = -1;
        /**
         * Lowest priority; these items might not be shown to the user except under special
         * circumstances, such as detailed notification logs.
         */
        public static const MIN:int = -2;

        /**
         * @private
         */
        public function NotificationPriority() {
            throw new Error("Cannot create an instance of this class");
        }
    }

}