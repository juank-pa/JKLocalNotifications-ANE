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


package com.juankpro.ane.localnotif;


import java.util.List;

import android.app.ActivityManager;
import android.app.Notification;
import android.app.ActivityManager.RunningAppProcessInfo;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;


public class AlarmIntentService extends BroadcastReceiver 
{	

	public final static String CLASS_NAME = "com.juankpro.ane.localnotif.AlarmIntentService";
	final static int STANDARD_NOTIFICATION_ID = 0;
	
	public final static String MAIN_ACTIVITY_CLASS_NAME_KEY = "com.juankpro.ane.localnotif.mainActivityClassNameKey";
	
	public final static String NOTIFICATION_CODE_KEY = "com.juankpro.ane.localnotif.notificationCodeKey";
	public final static String ACTION_DATA_KEY = "com.juankpro.ane.localnotif.actionDataKey";
	
	public static final String ICON_RESOURCE = "NOTIF_ICON_RESOURCE";
	public static final String TITLE = "NOTIF_TITLE";
	public static final String BODY = "NOTIF_BODY";
	public static final String NUMBER_ANNOTATION = "NOTIF_NUM_ANNOT";
	public static final String TICKER_TEXT = "NOTIF_TICKER";
	public static final String PLAY_SOUND = "NOTIF_PLAY_SOUND";
	public static final String SOUND_NAME = "NOTIF_SOUND_NAME";
	public static final String VIBRATE = "NOTIF_VIBRATE";
	public static final String CANCEL_ON_SELECT = "NOTIF_CANCEL_OS";
	public static final String REPEAT_UNTIL_ACKNOWLEDGE = "NOTIF_RUA";
	public static final String ON_GOING = "NOTIF_ONGOING";
	public static final String ALERT_POLICY = "NOTIF_POLICY";
	public static final String HAS_ACTION = "NOTIF_HAS_ACTION";
	
    @Override
    public void onReceive(Context context, Intent intent)
    {	
    	Bundle bundle = intent.getExtras();
    	
		//boolean isAppInForeground = isAppInForeground(context);

		//if (!isAppInForeground)
		//{
			if(LocalNotificationManager.freContextInstance == null)
			{
				Log.d("AlarmIntentService::onReceive", "App is not running");
			}
			else
			{
				Log.d("AlarmIntentService::onReceive", "App is running in background");
			}
			
			boolean hasAction = bundle.getBoolean(HAS_ACTION);

			int iconResourceId = bundle.getInt(ICON_RESOURCE);
			int numberAnnotation = bundle.getInt(NUMBER_ANNOTATION);
			String tickerText = bundle.getString(TICKER_TEXT);
			String title = bundle.getString(TITLE);
			String body = bundle.getString(BODY);
			String code = bundle.getString(NOTIFICATION_CODE_KEY);
			
			// Create the notification, passing in the icon, ticker text and time.
			Notification notification = new Notification(iconResourceId, tickerText, System.currentTimeMillis());
			notification.flags = 0;
			notification.defaults = 0;

			// Set up the various categories of properties of the notification.
			setupSound(context, intent, notification);
			setupVibrate(intent, notification);
			setupLight(notification);
			setupMiscellaneous(intent, notification);
			
			notification.number = numberAnnotation;

			final Intent notificationIntent = new Intent();
			
			if (hasAction)
			{
				String activityClassName = bundle.getString(MAIN_ACTIVITY_CLASS_NAME_KEY);
				byte actionData[] = bundle.getByteArray(ACTION_DATA_KEY);
				
				notificationIntent.setClassName(context, "com.juankpro.ane.localnotif.LocalNotificationIntentService");
				notificationIntent.putExtra(MAIN_ACTIVITY_CLASS_NAME_KEY, activityClassName);
				
				Log.d("AlarmIntentService::onReceive", "Activity Class Name: " + activityClassName);
				
				// Add the notification code of the notification to the intent so we can retrieve it later if the notification is selected by a user.
				notificationIntent.putExtra(NOTIFICATION_CODE_KEY, code);
				
				// Add the action data of the notification to the intent as well.
				notificationIntent.putExtra(ACTION_DATA_KEY, actionData);
			}
			
			final PendingIntent pendingIntent = PendingIntent.getService(context, code.hashCode(), notificationIntent, PendingIntent.FLAG_CANCEL_CURRENT);
			notification.setLatestEventInfo(context, title, body, pendingIntent);

			// Fire the notification.
			final NotificationManager notificationManager = (NotificationManager)context.getSystemService(Context.NOTIFICATION_SERVICE);
			notificationManager.notify(code, STANDARD_NOTIFICATION_ID, notification);
		/*}
		else if (LocalNotificationManager.freContextInstance != null)
		{
			LocalNotificationManager.selectedNotificationCode = intent.getStringExtra(NOTIFICATION_CODE_KEY);
			LocalNotificationManager.selectedNotificationData = intent.getByteArrayExtra(ACTION_DATA_KEY);
			LocalNotificationManager.wasNotificationSelected = false;
				
			LocalNotificationManager.freContextInstance.dispatchNotificationSelectedEvent();

			Log.d("AlarmIntentService::onReceive", "App is running in foreground");
		}*/
		
		Log.d("AlarmIntentService::onReceive", "Intent: " + intent.toString());
    }
    
	private void setupSound(Context context, Intent intent, Notification notification)
	{
		final Bundle bundle = intent.getExtras();
		boolean playSound = bundle.getBoolean(PLAY_SOUND);
		String soundName = bundle.getString(SOUND_NAME);
		
		if (playSound)
		{
			if(soundName != null && soundName.length() > 0)
			{
				int pointIndex = soundName.indexOf('.');
				if(pointIndex != -1)
				{
					soundName = soundName.substring(0, pointIndex);
				}
				Uri path = Uri.parse("android.resource://" + context.getPackageName() + "/raw/" + soundName);
				notification.sound = path;
			}
			else
			{
				notification.sound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
			}
		}
		else
		{
			notification.sound = null;
		}
	}
	
	
	private void setupVibrate(Intent intent, Notification notification)
    {
		final Bundle bundle = intent.getExtras();
		boolean vibrate = bundle.getBoolean(VIBRATE);
		
		if (vibrate)
        {
    		notification.defaults |= Notification.DEFAULT_VIBRATE;
    	}
        else
        {
        	long [] emptyVibrationPattern = {0};
        	notification.vibrate = emptyVibrationPattern;
        }
    }
	
	
	private void setupLight(Notification notification)
    {
		notification.defaults |= Notification.DEFAULT_LIGHTS;
    }
	
	
	private void setupMiscellaneous(Intent intent, Notification notification)
	{
		final Bundle bundle = intent.getExtras();
		boolean cancelOnSelect = bundle.getBoolean(CANCEL_ON_SELECT);
		boolean repeatAlertUntilAcknowledged = bundle.getBoolean(REPEAT_UNTIL_ACKNOWLEDGE);
		boolean ongoing = bundle.getBoolean(ON_GOING);
		String alertPolicy = bundle.getString(ALERT_POLICY);
		
		if (cancelOnSelect)
        {
        	notification.flags |= Notification.FLAG_AUTO_CANCEL;
        }
    	if (repeatAlertUntilAcknowledged)
    	{
    		notification.flags |= Notification.FLAG_INSISTENT;
    	}
    	// IMPORTANT: The alertPolicy string values map directly to the constants in the NotificationAlertPolicy class in the ActionScript interface.
    	if (alertPolicy.compareTo("firstNotification") == 0)
    	{
    		notification.flags |= Notification.FLAG_ONLY_ALERT_ONCE;
    	}
    	if (ongoing)
    	{
    		notification.flags |= Notification.FLAG_ONGOING_EVENT;
    	}
	}
       
    /*private boolean isAppInForeground(Context context) 
    {
        ActivityManager activityManager = (ActivityManager)context.getSystemService(Context.ACTIVITY_SERVICE);
        List<RunningAppProcessInfo> appProcesses = activityManager.getRunningAppProcesses();
        if (appProcesses != null) 
        {
        	final String packageName = context.getPackageName();
        	Log.d("AlarmIntentService::isAppInForeground", "PackageName:" + packageName);
            for (RunningAppProcessInfo appProcess : appProcesses) 
            {
            	if (appProcess.importance == RunningAppProcessInfo.IMPORTANCE_FOREGROUND && appProcess.processName.equals(packageName)) 
            	{
            		return true;
            	}
            }
        }
        
        return false;
    }*/
}

