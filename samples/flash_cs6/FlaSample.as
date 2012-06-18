﻿package  {
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import com.juankpro.ane.localnotif.NotificationManager;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import com.juankpro.ane.localnotif.Notification;
	import com.juankpro.ane.localnotif.NotificationEvent;
	import flash.text.TextField;
	
	public class FlaSample extends MovieClip {
		
		private var notificationManager:NotificationManager;
		
		public var button1:SimpleButton;
		public var button2:SimpleButton;
		public var button3:SimpleButton;
		public var notificationTF:TextField;
		
		private static const NOTIFICATION_CODE:String = "NOTIFICATION_CODE_001";
		
		public function FlaSample() 
		{
			if(NotificationManager.isSupported)
			{
				notificationManager = new NotificationManager();
				
				notificationManager.addEventListener(NotificationEvent.NOTIFICATION_ACTION, notificationActionHandler);
				button1.addEventListener(MouseEvent.CLICK, buttonClickHandler);
				button2.addEventListener(MouseEvent.CLICK, buttonClickHandler);
				button3.addEventListener(MouseEvent.CLICK, buttonClickHandler);
			}
		}
		
		private function buttonClickHandler(event:MouseEvent):void
		{
			switch(event.target)
			{
				case button1:
					var notification:Notification = new Notification();
					notification.actionLabel = "OK";
					notification.body = "Body sample";
					notification.title = "Title";
					notification.soundName = "fx05.caf";
					notification.fireDate = new Date((new Date()).time + (15 * 1000));
					notification.numberAnnotation = 1;
					notification.actionData = {sampleData:"Hello World!"}

					notificationManager.notifyUser(NOTIFICATION_CODE, notification);
				break;
				case button2:
					notificationManager.cancel(NOTIFICATION_CODE);
				break;
				case button3:
					notificationManager.applicationBadgeNumber = 0;
					notificationTF.text = "";
				break;
			}
		}
		
		private function notificationActionHandler(event:NotificationEvent):void
		{
			notificationTF.text = "Notification Code: " + event.notificationCode +
				"\nSample Data: {" + event.actionData.sampleData + "}\n\n";
		}
	}
	
}
