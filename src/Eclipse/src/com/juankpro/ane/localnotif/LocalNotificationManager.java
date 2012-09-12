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


import java.util.Map;
import java.util.Set;

import android.app.AlarmManager;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.util.Log;


public class LocalNotificationManager 
{	
	public final static String ANE_NAME = "JK_ANE_LocalNotification";
	
	Context androidActivity;
	Context androidContext;
	NotificationManager notificationManager;
	
	public static boolean wasNotificationSelected = false;
	public static String selectedNotificationCode = "";
	public static byte[] selectedNotificationData = {};
	public static LocalNotificationsContext freContextInstance = null;
	
	/**
	 * Represents a second in milliseconds
	 */
	private final static long SECOND_CALENDAR_UNIT_MS = 1000;
	/**
	 * Represents a minute in milliseconds
	 */
	private final static long MINUTE_CALENDAR_UNIT_MS = SECOND_CALENDAR_UNIT_MS * 60;
	/**
	 * Represents a week in milliseconds
	 */
	private final static long HOUR_CALENDAR_UNIT_MS = MINUTE_CALENDAR_UNIT_MS * 60;
	/**
	 * Represents a day in milliseconds
	 */
	private final static long DAY_CALENDAR_UNIT_MS = HOUR_CALENDAR_UNIT_MS * 24;
	/**
	 * Represents a month in milliseconds
	 * Not exact
	 */
	private final static long MONTH_CALENDAR_UNIT_MS = DAY_CALENDAR_UNIT_MS * 30;
	/**
	 * Represents a year in milliseconds
	 * Not exact
	 */
	private final static long YEAR_CALENDAR_UNIT_MS = DAY_CALENDAR_UNIT_MS * 365;
	/**
	 * Represents a year in milliseconds
	 * Not supported
	 */
	private final static long ERA_CALENDAR_UNIT_MS = YEAR_CALENDAR_UNIT_MS;
	/**
	 * Represents an hour in milliseconds
	 */
	private final static long WEEK_CALENDAR_UNIT_MS = DAY_CALENDAR_UNIT_MS * 7;
	/**
	 * Represents a week day (e.g. each Monday) in milliseconds
	 */
	private final static long WEEKDAY_CALENDAR_UNIT_MS = DAY_CALENDAR_UNIT_MS * 7;
	/**
	 * Represents a week day ordinal in milliseconds
	 * Not supported
	 */
	private final static long WEEKDAY_ORDINAL_CALENDAR_UNIT_MS = MONTH_CALENDAR_UNIT_MS;
	/**
	 * Represents a quarter year in milliseconds
	 * Not exact
	 */
	private final static long QUARTER_CALENDAR_UNIT_MS = YEAR_CALENDAR_UNIT_MS / 4;
	
	
	
	
	/**
	 * Represents an era repeat interval
	 */
	public final static int ERA_CALENDAR_UNIT = 1 << 1;
	/**
	 * Represents a year repeat interval
	 */
	public final static int YEAR_CALENDAR_UNIT = 1 << 2;
	/**
	 * Represents a month repeat interval
	 */
	public final static int MONTH_CALENDAR_UNIT = 1 << 3;
	/**
	 * Represents a day repeat interval
	 */
	public final static int DAY_CALENDAR_UNIT = 1 << 4;
	/**
	 * Represents an hour repeat interval
	 */
	public final static int HOUR_CALENDAR_UNIT = 1 << 5;
	/**
	 * Represents a minute repeat interval
	 */
	public final static int MINUTE_CALENDAR_UNIT = 1 << 6;
	/**
	 * Represents a second repeat interval
	 */
	public final static int SECOND_CALENDAR_UNIT = 1 << 7;
	/**
	 * Represents a week repeat interval
	 */
	public final static int WEEK_CALENDAR_UNIT = 1 << 8;
	/**
	 * Represents a week day (e.g. each Monday) repeat interval
	 */
	public final static int WEEKDAY_CALENDAR_UNIT = 1 << 9;
	/**
	 * Represents a week day ordinal repeat interval
	 */
	public final static int WEEKDAY_ORDINAL_CALENDAR_UNIT = 1 << 10;
	/**
	 * Represents a quarter year repeat interval
	 */
	public final static int QUARTER_CALENDAR_UNIT = 1 << 11;

	static public long mapIntervalToMilliseconds(int interval)
	{
		switch(interval)
		{
		case ERA_CALENDAR_UNIT:
			return ERA_CALENDAR_UNIT_MS;
		case YEAR_CALENDAR_UNIT:
			return YEAR_CALENDAR_UNIT_MS;
		case MONTH_CALENDAR_UNIT:
			return MONTH_CALENDAR_UNIT_MS;
		case DAY_CALENDAR_UNIT:
			return DAY_CALENDAR_UNIT_MS;
		case HOUR_CALENDAR_UNIT:
			return HOUR_CALENDAR_UNIT_MS;
		case MINUTE_CALENDAR_UNIT:
			return MINUTE_CALENDAR_UNIT_MS;
		case SECOND_CALENDAR_UNIT:
			return SECOND_CALENDAR_UNIT_MS;
		case WEEK_CALENDAR_UNIT:
			return WEEK_CALENDAR_UNIT_MS;
		case WEEKDAY_CALENDAR_UNIT:
			return WEEKDAY_CALENDAR_UNIT_MS;
		case WEEKDAY_ORDINAL_CALENDAR_UNIT:
			return WEEKDAY_ORDINAL_CALENDAR_UNIT_MS;
		case QUARTER_CALENDAR_UNIT:
			return QUARTER_CALENDAR_UNIT_MS;
		default:
			return 0;
		}
	}
	
	
	public LocalNotificationManager(Context activity)
	{
		androidActivity = activity;
		
		androidContext = activity.getApplicationContext();
		
		notificationManager = (NotificationManager)androidContext.getSystemService(android.content.Context.NOTIFICATION_SERVICE);
		
		Log.d("LocalNotificationManager::initialize", "Called with activity: " + activity.toString());
	}
	
	
	public void notify(LocalNotification localNotification)
	{
		// Time.
		long notificationTime = localNotification.fireDate.getTime();
		
		final Intent intent = new Intent(androidContext, AlarmIntentService.class);
		
		intent.setAction(localNotification.code);
		intent.putExtra(AlarmIntentService.TITLE, localNotification.title);
		intent.putExtra(AlarmIntentService.BODY, localNotification.body);
		intent.putExtra(AlarmIntentService.TICKER_TEXT, localNotification.tickerText);
		intent.putExtra(AlarmIntentService.NOTIFICATION_CODE_KEY, localNotification.code);
		intent.putExtra(AlarmIntentService.ICON_RESOURCE, localNotification.iconResourceId);
		intent.putExtra(AlarmIntentService.NUMBER_ANNOTATION, localNotification.numberAnnotation);
		intent.putExtra(AlarmIntentService.PLAY_SOUND, localNotification.playSound);
		intent.putExtra(AlarmIntentService.SOUND_NAME, localNotification.soundName);
		intent.putExtra(AlarmIntentService.VIBRATE, localNotification.vibrate);
		intent.putExtra(AlarmIntentService.CANCEL_ON_SELECT, localNotification.cancelOnSelect);
		intent.putExtra(AlarmIntentService.REPEAT_UNTIL_ACKNOWLEDGE, localNotification.repeatAlertUntilAcknowledged);
		intent.putExtra(AlarmIntentService.ON_GOING, localNotification.ongoing);
		intent.putExtra(AlarmIntentService.ALERT_POLICY, localNotification.alertPolicy);
		intent.putExtra(AlarmIntentService.HAS_ACTION, localNotification.hasAction);
		intent.putExtra(AlarmIntentService.ACTION_DATA_KEY, localNotification.actionData);
		
		Log.d("LocalNotificationManager", "when:" + String.valueOf(notificationTime) + ", current:" + System.currentTimeMillis());

		
		// If a notification is specified to have an action, set up the intent to launch the app when the notification is selected by a user.
		if (localNotification.hasAction)
		{
			intent.putExtra(AlarmIntentService.MAIN_ACTIVITY_CLASS_NAME_KEY, localNotification.activityClassName);
			Log.d("LocalNotificationManager::notify", "Activity Class Name: " + localNotification.activityClassName);
		}
		
		final PendingIntent pendingIntent = PendingIntent.getBroadcast(androidContext, localNotification.code.hashCode(), intent, PendingIntent.FLAG_CANCEL_CURRENT);
		final AlarmManager am = getAlarmManager();
		
		long repeatInterval = mapIntervalToMilliseconds(localNotification.repeatInterval);
		
		if (repeatInterval != 0) 
		{
		    am.setRepeating(AlarmManager.RTC_WAKEUP, notificationTime, repeatInterval, pendingIntent);
		} 
		else 
		{
		    am.set(AlarmManager.RTC_WAKEUP, notificationTime, pendingIntent);
		}
		
		Log.d("LocalNotificationManager::notify", "Called with notification code: " + localNotification.code);
	}
	
	
	public void cancel(String notificationCode)
	{		
		/*
		 * Create an intent that looks similar, to the one that was registered
		 * using add. Making sure the notification id in the action is the same.
		 * Now we can search for such an intent using the 'getService' method
		 * and cancel it.
		 */
		final Intent intent = new Intent(androidContext, AlarmIntentService.class);
		intent.setAction(notificationCode);

		final PendingIntent pi = PendingIntent.getBroadcast(androidContext, notificationCode.hashCode(), intent, PendingIntent.FLAG_CANCEL_CURRENT);
		final AlarmManager am = getAlarmManager();

		try 
		{
		    am.cancel(pi);
			Log.d("LocalNotificationManager::cancel", "Called with notification code: " + notificationCode);
		} 
		catch (Exception e) 
		{
			Log.d("LocalNotificationManager::cancel", "Exception: " + e.getMessage());		    
		}
		
		notificationManager.cancel(notificationCode, AlarmIntentService.STANDARD_NOTIFICATION_ID);		
	}
	

    private AlarmManager getAlarmManager() 
    {
		final AlarmManager am = (AlarmManager) androidContext.getSystemService(Context.ALARM_SERVICE);
		return am;
    }
	
	
	public void cancelAll()
	{		
		final SharedPreferences alarmSettings = androidContext.getSharedPreferences(ANE_NAME, Context.MODE_PRIVATE);
		
		final Map<String, ?> allAlarms = alarmSettings.getAll();
		final Set<String> alarmIds = allAlarms.keySet();

		for (String alarmId : alarmIds) 
		{
		    Log.d(ANE_NAME, "Canceling notification with id: " + alarmId);
		    String alarmCode = alarmId;
		    cancel(alarmCode);
		}
		
		notificationManager.cancelAll();
		
		Log.d("LocalNotificationManager::cancelAll", "Called");
	}
	
		
	/**
     * Persist the information of this notification to the Android Shared Preferences.
     * This will allow the application to restore the alarm upon device reboot.
     * Also this is used by the cancelAllNotifications method.
     * 
     * @see #cancelAllNotifications()
     * 
     * @param notification
     *            The notification to persist.
     */
    public void persistNotification(LocalNotification notification) 
    {
    	Log.d("LocalNotificationManager::persistNotification", "Notification: " + notification.code);
    	final SharedPreferences alarmSettings = androidContext.getSharedPreferences(ANE_NAME, Context.MODE_PRIVATE);    	
    	notification.serialize(alarmSettings);
    }
    
    /**
     * Remove a specific notification from the Android shared Preferences
     * 
     * @param notification
     *            The notification to persist.
     */
    public void unpersistNotification(String notificationCode) 
    {
    	Log.d("LocalNotificationManager::unpersistNotification", "Notification: " + notificationCode);
    	final Editor alarmSettingsEditor = androidContext.getSharedPreferences(ANE_NAME, Context.MODE_PRIVATE).edit();
    	alarmSettingsEditor.remove(notificationCode);
    	alarmSettingsEditor.commit();
    }
    
    /**
     * Clear all notifications from the Android shared Preferences
     */
    public void unpersistAllNotifications() 
    {
    	Log.d("LocalNotificationManager::unpersistAllNotifications", "Called");
		final Editor alarmSettingsEditor = androidContext.getSharedPreferences(ANE_NAME, Context.MODE_PRIVATE).edit();
		alarmSettingsEditor.clear();
		alarmSettingsEditor.commit();
    }
}

