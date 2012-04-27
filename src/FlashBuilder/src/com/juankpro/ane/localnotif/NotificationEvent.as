package com.juankpro.ane.localnotif
{
    import flash.events.*;

	/**
	 * NotificationEvent is an Event that is fired when a Notification is selected.
	 * <p>Supported OS: Android, iOS</p>
	 */
    public class NotificationEvent extends Event
    {
		/**
		 * The data associated with the notification that this event pertains to.
		 * <p>Supported OS: Android, iOS</p>
		 * @default null
		 */
        public var actionData:Object = null;
		
		/**
		 * The code of the notification that this event pertains to.
		 * <p>Supported OS: Android, iOS</p>
		 * @default null
		 */
        public var notificationCode:String = null;
		
		/**
		 * A string constant representing the notification action event type.
		 * <p>Supported OS: Android, iOS</p>
		 */
        public static const NOTIFICATION_ACTION:String = "notificationAction";

		/**
		 * Constructs a new NotificationEvent object with the specified parameters.
		 * <p>Supported OS: Android, iOS</p>
		 */
        public function NotificationEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false, code:String = null, data:Object = null)
        {
            super(type, bubbles, cancelable);
            this.notificationCode = code;
            this.actionData = data;
            return;
        }

		/**
		 * @private
		 */
        override public function clone() : Event
        {
            return new NotificationEvent(type, bubbles, cancelable, this.notificationCode, this.actionData);
        }

		/**
		 * @private
		 */
        override public function toString() : String
        {
            return formatToString("NotificationEvent", "type", "bubbles", "cancelable", "eventPhase", "notificationCode", "actionData");
        }

    }
}
