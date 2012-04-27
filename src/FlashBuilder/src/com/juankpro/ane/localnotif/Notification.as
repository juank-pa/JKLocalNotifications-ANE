package com.juankpro.ane.localnotif
{

	/**
	 * A class that represents how a persistent local notification is to be presented to the user using the NotificationManager class.
	 * <p>Supported OS: Android, iOS</p>
	 */
    public class Notification extends Object
    {
		/**
		 * The data associated with the notification. It can be retrieved from a NotificationEvent object. 
		 * <p>Supported OS: Android, iOS</p>
		 * @default null
		 */
        public var actionData:Object = null;
		
		/**
		 * The text associated with the notification action - it appears in two places. 
		 * The first is on the action button of the notification dialog that appears when a notification is fired. 
		 * The second is on the unlock slider when the device is locked. If left as null, the iOS default string will be used.
		 * <p>Supported OS: iOS </p>
		 * @default null
		 */
        public var actionLabel:String = null;
		
		/**
		 * Specifies when a notification will alert the user.
		 * <p>Supported OS: Android</p>
		 * @default NotificationAlertPolicy.EACH_NOTIFICATION
		 */
        public var alertPolicy:String;
		
		/**
		 * The body text of the notification.
		 * <p>Supported OS: Android, iOS</p>
		 * @default value is null.
		 */
        public var body:String = null;
		
		/**
		 * Specifies if the notification is cleared from the notifications list and status bar after it is selected.
		 * <p>Supported OS: Android</p>
		 * @default true
		 */
        public var cancelOnSelect:Boolean = false;
		
		/**
		 * Specifies if the notification has an action or not. On both OSs, if a notification's action is performed, 
		 * at the very least, the app will be brought to the foreground if it was in the background or 
		 * launched if it had been shutdown. On iOS, the way to perform the action of a notification manifests itself 
		 * as a button on the notification dialog that appears when a notification is fired and different text on 
		 * the unlock slider when the device is locked. On Android, the way to perform an action is not visible, 
		 * it is performed by selecting the notification from the notification list (window shade).
		 * <p>Supported OS: Android, iOS</p>
		 * @default true
		 */
        public var hasAction:Boolean = true;
		
		/**
		 * Specifies the type of icon to display with the notification, specified by the NotificationIconType class.
		 * <p>Supported OS: Android</p>
		 * @default NotificationIconType.ALERT
		 */
        public var iconType:String;
		
		/**
		 * On Android this will display the specified number on the notification icon that appears 
		 * in the status bar. On iOS this will display as a number on the application icon's badge. 
		 * Numbers 0 and below will result in no badge displayed.
		 * <p>Supported OS: Android, iOS</p>
		 * @default 0
		 */
        public var numberAnnotation:int = 0;
		
		/**
		 * The notification will be placed in the "Ongoing" category of the notifications list instead of the 
		 * "Notifications" category and cannot be cleared with the Clear button.
		 * <p>Supported OS: Android</p>
		 * @default false
		 */
        public var ongoing:Boolean = false;
		
		/**
		 * Specifies if a sound will be played when the notification arrives. 
		 * The sound and the volume that it's played at are defined by the user settings on the OS.
		 * <p>Supported OS: Android, iOS</p>
		 * @default true
		 */
        public var playSound:Boolean = true;
		
		/**
		 * The alert (sound and vibration) of a notification will be repeated until it is canceled or the notifications list is opened.
		 * <p>Supported OS: Android</p>
		 * @default false
		 */
        public var repeatAlertUntilAcknowledged:Boolean = false;
		
		/**
		 * The text that is displayed in the status bar when the notification first arrives. 
		 * <p>Supported OS: Android</p>
		 * @default null
		 */
        public var tickerText:String = null;
		
		/**
		 * The title of the notification.
		 * <p>Supported OS: Android</p>
		 * @default null
		 */
        public var title:String = null;
		
		/**
		 * Specifies if the device should vibrate when a notification arrives.
		 * <p>Supported OS: Android</p>
		 * @default true
		 */
        public var vibrate:Boolean = true;
		
		/**
		 * The date and time when the system should deliver the notification.
		 * <p>Supported OS: iOS</p>
		 * @default null
		 */
		public var fireDate:Date;
		
		/**
		 * The calendar interval at which to reschedule the notification.
		 * If you assign an calendar unit the system reschedules the notification for 
		 * delivery at the specified interval.
		 * <p>Use the constants defined on <code>NotificationTimeInterval</code> or
		 * zero if you want the notification to trigger only once.</p>
		 * <p>Supported OS: iOS</p>
		 * @default 0 which means don't repeat
		 * @see com.juankpro.ane.localnotif.NotificationTimeInterval
		 */
		public var repeatInterval:uint = 0;

		/**
		 * Initializes the notification.
		 * <p>Supported OS: Android, iOS</p>
		 */
        public function Notification()
        {
            alertPolicy = NotificationAlertPolicy.EACH_NOTIFICATION;
            iconType = NotificationIconType.ALERT;
        }
    }
}
