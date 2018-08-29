package com.juankpro.ane.localnotif {
	/**
	 * A class of constants representing the different repeat intervals available to use with the
	 * repeatInterval property of the Notification class.
	 * <p>Supported OS: iOS, Android</p>
	 * @see com.juankpro.ane.localnotif.Notification#repeatInterval
	 */
	public class NotificationTimeInterval {
		/**
		 * Represents a year repeat interval
		 * <p>Supported OS: iOS, Android</p>
		 */
		public static const YEAR_CALENDAR_UNIT:uint = 1 << 2;
		/**
		 * Represents a month repeat interval
		 * <p>Supported OS: iOS, Android</p>
		 */
		public static const MONTH_CALENDAR_UNIT:uint = 1 << 3;
		/**
		 * Represents a day repeat interval
		 * <p>Supported OS: iOS, Android</p>
		 */
		public static const DAY_CALENDAR_UNIT:uint = 1 << 4;
		/**
		 * Represents an hour repeat interval
		 * <p>Supported OS: iOS, Android</p>
		 */
		public static const HOUR_CALENDAR_UNIT:uint = 1 << 5;
		/**
		 * Represents a minute repeat interval. On Android 6.0 (API level 23) this interval might
	 	 * not trigger very frequently while in doze mode, even when setting the notification
	 	 * <code>allowWhileIdle</code> property to true. Doze mode will restrict these alarms
	 	 * to trigger only once every 10 to 15 minutes.
		 * <p>Supported OS: iOS, Android</p>
	 	 * @see com.juankpro.ane.localnotif.Notification#allowWhileIdle
		 */
		public static const MINUTE_CALENDAR_UNIT:uint = 1 << 6;
		/**
		 * Represents a week repeat interval
		 * <p>Supported OS: iOS, Android</p>
		 */
		public static const WEEK_CALENDAR_UNIT:uint = 1 << 13;
		/**
		 * Represents a quarter year repeat interval.
		 * Will just trigger every 91 days.
		 * <p>Supported OS: Android</p>
		 */
		public static const QUARTER_CALENDAR_UNIT:uint = 1 << 11;

		/**
		 * @private
		 */
		public function NotificationTimeInterval() {
			throw new Error("Cannot create an instance of this class");
		}
	}
}
