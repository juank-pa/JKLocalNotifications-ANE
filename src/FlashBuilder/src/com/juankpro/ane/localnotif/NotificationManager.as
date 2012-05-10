package com.juankpro.ane.localnotif
{
	import flash.desktop.NativeApplication;
	import flash.events.*;
	import flash.external.*;
	import flash.utils.*;
	
	/**
	 * A class to notify the user of events that happen through notifications; it is used in conjunction 
	 * with the Notification class. If you want to receive a NotificationEvent when a user has selected a 
	 * notification, you must call addEventListener on your NotificationManager object when your 
	 * app is launched (like in creationComplete for example).
	 * <p>Supported OS: Android, iOS</p>
	 */
	public class NotificationManager extends EventDispatcher
	{
		CONFIG::device private static var _extensionContext:ExtensionContext = null;
		CONFIG::device private static var _refCount:int = 0;
		
		CONFIG::device private static const _contextType:String = "LocalNotificationsContext";
		
		CONFIG::device private static const STATUS:String = "status";
		CONFIG::device private static const NOTIFICATION_SELECTED:String = "notificationSelected";
				
		CONFIG::device private var _disposed:Boolean;
		
		/**
		 * Determine whether notifications are available for this platform or not.
		 * <p>Supported OS: All</p>
		 */
		public static function get isSupported():Boolean
		{
			CONFIG::device
			{
				return true;
			}
			return false;
		}
	
		/**
		 * Initializes the notification manager.
		 * <p>Supported OS: Android, iOS</p>
		 */
		public function NotificationManager()
		{
			CONFIG::device
			{
				if(_extensionContext == null)
				{
					_extensionContext = ExtensionContext.createExtensionContext("com.juankpro.ane.LocalNotification", _contextType);
					_extensionContext.call("createManager");
				}
				_refCount++;
			}
		}
	
		/**
		 * @private
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			CONFIG::device
			{
				if(_disposed) return;
				
				_extensionContext.addEventListener(StatusEvent.STATUS, onStatusEventReceived);
				_extensionContext.call("checkForNotificationAction");
			}
		}
	
		/**
		 * Cancels the notification specified by the notification code.
		 * <p>Supported OS: Android, iOS</p>
		 * @param code The code of the notification to cancel
		 */
		public function cancel(code:String):void
		{
			CONFIG::device
			{
				if(_disposed) return;
				
				_extensionContext.call("cancel", code);
			}
		}
	
		/**
		 * Cancels all notifications.
		 * <p>Supported OS: Android, iOS</p>
		 */
		public function cancelAll():void
		{
			CONFIG::device
			{
				if(_disposed) return;
				
				_extensionContext.call("cancelAll");
			}
		}
		
		/**
		 * Fires the specified notification. On Android this will place the notification in the notification area, 
		 * accessible by sliding down the drawer. iOS handles notifications slightly differently: if the application 
		 * is running when the notification is dispatched, you won’t receive a pop-up; if the application is running 
		 * in the background (multitasking by using a background API), you’ll receive the pop-up dialog box when the 
		 * notification is dispatched. 
		 * <p>Supported OS: Android, iOS</p>
		 * @param code An identifier for this notification that is unique to the application. 
		 * The code can later be used to cancel the notification using the cancel method.
		 * @param notification A Notification object describing how to notify the user. Must not be null.
		 */
		public function notifyUser(code:String, notification:Notification):void
		{
			CONFIG::device
			{
				if(_disposed) return;
				
				if (notification.actionData != null)
				{
					var data:ByteArray = new ByteArray();
					data.writeObject(notification.actionData);
					notification.actionData = data;
				}
				_extensionContext.call("notify", code, notification);
			}
		}
	
		/**
		 * @private
		 */
		CONFIG::device private function onStatusEventReceived(event:StatusEvent):void
		{
			if (event.code == NOTIFICATION_SELECTED)
			{
				var notificationEvent:NotificationEvent = new NotificationEvent(NotificationEvent.NOTIFICATION_ACTION, true, false);
				var data:ByteArray = _extensionContext.call("getSelectedNotificationData") as ByteArray;
				data.position = 0;
				
				try
				{
					notificationEvent.actionData = data.readObject();
				}
				catch (e:Error){}
				
				notificationEvent.notificationCode = String(_extensionContext.call("getSelectedNotificationCode"));
				dispatchEvent(notificationEvent);
			}
			else
			{
				dispatchEvent(event);
			}
		}
		
		/**
		 * The application badge number. You can read and write this property.
		 * This property allows reseting the application badge to zero or
		 * any other value anytime.
		 * <p>Supproted OS: iOS</p>
		 */
		public function get applicationBadgeNumber():int
		{
			CONFIG::device
			{
				CONFIG::iphone
				{
					return _extensionContext.call("getApplicationBadgeNumber") as int;
				}
			}
			return 0;
		}
		
		/**
		 * @private
		 */
		public function set applicationBadgeNumber(value:int):void
		{
			CONFIG::device
			{
				CONFIG::iphone
				{
					_extensionContext.call("setApplicationBadgeNumber", value);
				}
			}
		}
		
		/**
		 * Removes the Notification Manager from memory.
		 * Once disposed any calls to the object methods will be ignored.
		 * <p>Supproted OS: Android, iOS</p>
		 */
		public function dispose():void
		{
			CONFIG::device
			{
				if(!_disposed)
				{
					_disposed = true;
					_extensionContext.removeEventListener(StatusEvent.STATUS, onStatusEventReceived);
					
					_refCount--;
					if(_refCount == 0)
					{
						_extensionContext.dispose();
						_extensionContext = null;
					}
				}
			}
		}
	}
}
