/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2011 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/


package com.adobe.ep.localnotifications;


import com.adobe.ep.extension.LocalNotificationsContext;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;
import android.util.Log;


public class LocalNotificationManager 
{	
	final static int STANDARD_NOTIFICATION_ID = 0;
	public final static String MAIN_ACTIVITY_CLASS_NAME_KEY = "com.adobe.ep.localnotifications.mainActivityClassNameKey";
	public final static String NOTIFICATION_CODE_KEY = "com.adobe.ep.localnotifications.notificationCodeKey";
	public final static String ACTION_DATA_KEY = "com.adobe.ep.localnotifications.actionDataKey";
	
	Context androidActivity;
	Context androidContext;
	NotificationManager notificationManager;
	
	public static boolean wasNotificationSelected = false;
	public static String selectedNotificationCode = "";
	public static byte[] selectedNotificationData = {};
	public static LocalNotificationsContext freContextInstance = null;
	
	
	public LocalNotificationManager(Context activity)
	{
		this.androidActivity = activity;
		
		androidContext = activity.getApplicationContext();
		
		notificationManager = (NotificationManager)androidContext.getSystemService(android.content.Context.NOTIFICATION_SERVICE);
		
		Log.d("LocalNotificationManager::initialize", "Called with activity: " + activity.toString());
	}
	
	
	public void notify(LocalNotification localNotification)
	{
		// Time.
		long notificationTime = System.currentTimeMillis();
		
		// Create the notification, passing in the icon, ticker text and time.
		Notification notification = new Notification(localNotification.iconResourceId, localNotification.tickerText, notificationTime);
		notification.flags = 0;
		notification.defaults = 0;

		// Set up the various categories of properties of the notification.
		setupSound(localNotification, notification);
		setupVibrate(localNotification, notification);
		setupLight(localNotification, notification);
		setupMiscellaneous(localNotification, notification);
		
		notification.number = localNotification.numberAnnotation;
		
		Intent intent = new Intent();
			
		// If a notification is specified to have an action, set up the intent to launch the app when the notification is selected by a user.
		if (localNotification.hasAction)
		{
			intent.setClassName(androidContext, "com.adobe.ep.localnotifications.LocalNotificationIntentService");
			intent.putExtra(MAIN_ACTIVITY_CLASS_NAME_KEY, localNotification.activityClassName);
			
			Log.d("LocalNotificationManager::notify", "Activity Class Name: " + localNotification.activityClassName);
			
			// Add the notification code of the notification to the intent so we can retrieve it later if the notification is selected by a user.
			intent.putExtra(NOTIFICATION_CODE_KEY, localNotification.code);
			
			// Add the action data of the notification to the intent as well.
			intent.putExtra(ACTION_DATA_KEY, localNotification.actionData);
		}
		
		PendingIntent pendingIntent = PendingIntent.getService(androidContext, localNotification.code.hashCode(), intent, PendingIntent.FLAG_CANCEL_CURRENT);

		notification.setLatestEventInfo(androidContext, localNotification.title, localNotification.body, pendingIntent);

		// Fire the notification.
		notificationManager.notify(localNotification.code, STANDARD_NOTIFICATION_ID, notification);
		
		Log.d("LocalNotificationManager::notify", "Called with notification code: " + localNotification.code);
	}
	
	
	public void cancel(String notificationCode)
	{
		notificationManager.cancel(notificationCode, STANDARD_NOTIFICATION_ID);
		
		Log.d("LocalNotificationManager::cancel", "Called with notification code: " + notificationCode);
	}
	
	
	public void cancelAll()
	{
		notificationManager.cancelAll();	
		
		Log.d("LocalNotificationManager::cancelAll", "Called");
	}
	
	
	private void setupSound(LocalNotification localNotification, Notification notification)
	{
		if (localNotification.playSound)
		{
			notification.sound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
		}
		else
		{
			notification.sound = null;
		}
	}
	
	
	private void setupVibrate(LocalNotification localNotification, Notification notification)
    {
    	if (localNotification.vibrate)
        {
    		notification.defaults |= Notification.DEFAULT_VIBRATE;
    	}
        else
        {
        	long [] emptyVibrationPattern = {0};
        	notification.vibrate = emptyVibrationPattern;
        }
    }
	
	
	private void setupLight(LocalNotification localNotification, Notification notification)
    {
		notification.defaults |= Notification.DEFAULT_LIGHTS;
    }
	
	
	private void setupMiscellaneous(LocalNotification localNotification, Notification notification)
	{
		if (localNotification.cancelOnSelect)
        {
        	notification.flags |= Notification.FLAG_AUTO_CANCEL;
        }
    	if (localNotification.repeatAlertUntilAcknowledged)
    	{
    		notification.flags |= Notification.FLAG_INSISTENT;
    	}
    	// IMPORTANT: The alertPolicy string values map directly to the constants in the NotificationAlertPolicy class in the ActionScript interface.
    	if (localNotification.alertPolicy.compareTo("firstNotification") == 0)
    	{
    		notification.flags |= Notification.FLAG_ONLY_ALERT_ONCE;
    	}
    	if (localNotification.ongoing)
    	{
    		notification.flags |= Notification.FLAG_ONGOING_EVENT;
    	}
	}
}

