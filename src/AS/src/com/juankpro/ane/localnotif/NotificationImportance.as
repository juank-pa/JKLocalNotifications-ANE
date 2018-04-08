package com.juankpro.ane.localnotif {
	/**
	 * A class of constants representing the amount of presence given to the notification
     * on Android devices. Use these constants for the <code>importance</code> property of
     * the <code>NotificationCategory</code> class for Android 7.0 (API level 24) and above.
     * <p>Lower Android API levels will use the <code>Notification.priority</code> property
     * set using one of the <code>NotificationPriority</code> class constants.
	 * <p>Supported OS: Android</p>
     * @see com.juankpro.ane.localnotif.NotificationCategory#importance
	 */
    final public class NotificationImportance {
        /**
         * Higher notification importance: shows everywhere, makes noise and peeks.
         */
        public static const HIGH:int = 4;
        /**
         * Default notification importance: shows everywhere, makes noise, but does not visually intrude.
         */
        public static const DEFAULT:int = 3;
        /**
         * Low notification importance: shows everywhere, but is not intrusive.
         */
        public static const LOW:int = 2;
        /**
         * Min notification importance: only shows in the shade, below the fold.
         */
        public static const MIN:int = 1;

        /**
         * @private
         */
        public function NotificationImportance() {
            throw new Error("Cannot create an instance of this class");
        }
    }

}