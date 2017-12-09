package com.juankpro.ane.localnotif {
    /**
     * This class represents a notification category. Notification categories
     * define the action buttons that the notification will show to the user.
     * Categories need to be registered first before sending any notification
     * associated with it using <code>NotificationManager.subscribe</code>.
     * @see com.juankpro.ane.localnotif.NotificationManager#subscribe()
     */
    public class NotificationCategory {
        /**
         * The identifier of the category. This identifier needs to be set as the
         * <code>Notification.category</code> value so that a given notification can refer
         * to the category.
         * <p>Supported OS: Android, iOS</p>
         * @see com.juankpro.ane.localnotif.NotificationManager#subscribe()
         * @see com.juankpro.ane.localnotif.Notification#category
         */
        public var identifier:String;

        /**
         * The action list for the category. This actions define the properties of the action
         * buttons to be shown for the notification. A maximum of four buttons will be visible
         * in the device screen depending on the operating system and device resolution.
         * <p>iOS 8 and previous versions show only the first two buttons in the
         * notification. Only notifications set to be shown as alerts show all four buttons
         * but this can only be set by the device user manually.</p>
         * <p>iOS 9 and later show all four buttons depending on the device size and resolution.
         * If there is not enough space it might show only the first two.</p>
         * <p>Android devices will show only the first three buttons.</p>
         * <p>Supported OS: Android, iOS</p>
         * @see com.juankpro.ane.localnotif.NotificationAction
         */
        public var actions:Vector.<NotificationAction>;

        /**
         * Constructor
         */
        public function NotificationCategory() { }
  }
}
