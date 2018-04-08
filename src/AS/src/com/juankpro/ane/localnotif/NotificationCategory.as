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
         * The name of the category. On Android 7.0 (API level 26) and higher this
         * name will be shown as the notifications channel name in the app notifications
         * settings.
         * <p>Supported OS: Android</p>
         */
        public var name:String;

        /**
         * The category description. On Android 7.0 (API level 26) and higher this
         * description will be shown to the user in the app notifications settings.
         * <p>Supported OS: Android</p>
         */
        public var description:String;

        /**
         * The sound to use for notifications sent through this category. This property
         * has effect on Android 7.0 (API level 26) and higher only. To support lower
         * versions set the sound properties at the <code>Notification</code> level as well.
         * <p>Supported OS: Android</p>
         * @see com.juankpro.ane.localnotif.Notification#playSound
         * @see com.juankpro.ane.localnotif.Notification#soundName
         */
        public var soundName:String;

        /**
         * The importance to use for notifications sent through this category. The importance
         * determines the amount of notifications visibility. Use the <code>NotificationImportance</code>
         * constants to set this property.
         * <p>This property has effect on Android 7.0 (API level 26) and higher only. To support lower
         * versions set the priority properties at the <code>Notification</code> level as well.</p>
         * <p>Supported OS: Android</p>
         * @see com.juankpro.ane.localnotif.NotificationImportance
         * @see com.juankpro.ane.localnotif.Notification#priority
         */
        public var importance:int;

        /**
         * Whether notifications sent through this category should vibrate. This property
         * has effect on Android 7.0 (API level 26) and higher only. To support lower
         * versions set the sound properties at the <code>Notification</code> level as well.
         * <p>Supported OS: Android</p>
         * @see com.juankpro.ane.localnotif.Notification#vibrate
         */
        public var shouldVibrate:Boolean = true;

        /**
         * The action list for the category. These actions define the properties of the action
         * buttons to be shown for the notification. A maximum of four buttons will be visible
         * on the device screen depending on the operating system and device resolution.
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
         * Determines whether dismissing notifications related to this category will trigger a
         * <code>NotificationEvent</code>. You can recognize the dismiss action event by its
         * <code>NotificationEvent.notificationAction</code> property that will have the
         * <code>Notification.NOTIFICATION_DISMISS_ACTION</code> value assigned to it.
         * The dismiss action is always triggered in the background.
         * <p>Only iOS 10 and higher support this feature. All versions of Android support this.</p>
         * <p>Supported OS: Android, iOS (10+)</p>
         * @see com.juankpro.ane.localnotif.NotificationEvent#notificationAction
         * @see com.juankpro.ane.localnotif.Notification#NOTIFICATION_DISMISS_ACTION
         */
        public var useCustomDismissAction:Boolean;
  }
}
