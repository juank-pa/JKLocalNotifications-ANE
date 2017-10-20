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


import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Map;

import android.util.Log;

import com.juankpro.ane.localnotif.LocalNotification;
import com.juankpro.ane.localnotif.LocalNotificationManager;
import com.adobe.fre.FREByteArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;


public class LocalNotificationsContext extends FREContext
{
	static final String STATUS = "status";
	static final String NOTIFICATION_SELECTED = "notificationSelected";
	
	LocalNotificationManager notificationManager;
	String selectedNotificationData = "";
	
	
	LocalNotificationsContext()
	{
		LocalNotificationManager.freContextInstance = this;
		
		Log.d("LocalNotificationsContext::LocalNotificationsContext", "cache instance");
	}
	
	
	@Override
	public void dispose()
	{
		LocalNotificationManager.freContextInstance = null;
		
		Log.d("LocalNotificationsContext::dispose", "set instance to null");
	}

	
	@Override
	public Map<String, FREFunction> getFunctions()
	{
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		
		functionMap.put("createManager", new FunctionHelper() 
		{
			@Override
			public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception
			{
				// Create a new notification manager and pass in the activity.
				notificationManager = new LocalNotificationManager(getActivity());
				
				return null;
			}
		});
		
		functionMap.put("checkForNotificationAction", new FunctionHelper() 
		{
			@Override
			public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception
			{
				// Check to see if a notification was selected from the window shade. If it was, reset
				// the flag and dispatch an event back to the ActionScript code so it can do something smart.
				if (LocalNotificationManager.wasNotificationSelected)
				{
					LocalNotificationManager.wasNotificationSelected = false;
					
					dispatchNotificationSelectedEvent();
				}
				
				return null;
			}
		});
		
		functionMap.put("getSelectedNotificationCode", new FunctionHelper() 
		{
			@Override
			public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception
			{
				Log.d("LocalNotificationsContext::getSelectedNotificationCode", "code: " + LocalNotificationManager.selectedNotificationCode);
				
				return FREObject.newObject(LocalNotificationManager.selectedNotificationCode);
			}
		});
		
		functionMap.put("getSelectedNotificationData", new FunctionHelper() 
		{
			@Override
			public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception
			{
				FREObject byteArray = FREObject.newObject("flash.utils.ByteArray", null);
				
				byte[] data = LocalNotificationManager.selectedNotificationData;
				int dataLength = data.length;
				
				// Construct an ActionScript ByteArray object containing the action data of the selected notification.
				for (int i = 0; i < dataLength; i++)
				{
					FREObject arguments[] = new FREObject[1];
					arguments[0] = FREObject.newObject(data[i]);
				
					byteArray.callMethod("writeByte", arguments);
				}
				
				Log.d("LocalNotificationsContext::getSelectedNotificationData", "byte array: " + new String(LocalNotificationManager.selectedNotificationData));
				
				return byteArray;
			}
		});
		
		functionMap.put("notify", new FunctionHelper() 
		{
			@Override
			public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception
			{
				LocalNotification localNotification = decodeLocalNotification(passedArgs[0].getAsString(), passedArgs[1], context);
				
				notificationManager.persistNotification(localNotification);
				// Fire the notification from the specified manager.				
				notificationManager.notify(localNotification);
				
				return null;
			}
		});
		
		functionMap.put("cancel", new FunctionHelper() 
		{
			@Override
			public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception
			{
				String notificationCode = passedArgs[0].getAsString();
				
				notificationManager.unpersistNotification(notificationCode);
				notificationManager.cancel(notificationCode);
				
				return null;
			}
		});
		
		functionMap.put("cancelAll", new FunctionHelper() 
		{
			@Override
			public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception
			{
				notificationManager.cancelAll();
				notificationManager.unpersistAllNotifications();
				
				return null;
			}
		});

		return functionMap;
	}
	
	
	public static LocalNotification decodeLocalNotification(String code, FREObject freObject, FREContext freContext) throws Exception
	{
		// Get the activity class name and pass it to the notification.
		String activityClassName = freContext.getActivity().getClass().getName();
		Log.d("LocalNotificationsContext::decodeLocalNotification", "Activity Class Name: " + activityClassName);
				
		LocalNotification localNotification = new LocalNotification(activityClassName);

		// Notification Name.
		localNotification.code = code;
		
		// IMPORTANT: These property names must match the names in the Notification ActionScript class exactly.

		localNotification.fireDate = ExtensionUtils.getDateProperty(freObject, "fireDate", localNotification.fireDate);
		localNotification.repeatInterval = ExtensionUtils.getIntProperty(freObject, "repeatInterval", localNotification.repeatInterval);
				
		// Text.
		localNotification.tickerText = ExtensionUtils.getStringProperty(freObject, "tickerText", localNotification.tickerText);
		localNotification.title = ExtensionUtils.getStringProperty(freObject, "title", localNotification.title);
		localNotification.body = ExtensionUtils.getStringProperty(freObject, "body", localNotification.body);
		
		// Sound.
		localNotification.playSound = ExtensionUtils.getBooleanProperty(freObject, "playSound", localNotification.playSound);
		localNotification.soundName = ExtensionUtils.getStringProperty(freObject, "soundName", localNotification.soundName);
		
		// Vibration.
		localNotification.vibrate = ExtensionUtils.getBooleanProperty(freObject, "vibrate", localNotification.vibrate);
		
		// Icon.
		String iconType = ExtensionUtils.getStringProperty(freObject, "iconType", "");
		localNotification.iconResourceId = getIconResourceIdFromString(iconType, freContext);
		localNotification.numberAnnotation = ExtensionUtils.getIntProperty(freObject, "numberAnnotation", localNotification.numberAnnotation);
		
		// Action.
		localNotification.hasAction = ExtensionUtils.getBooleanProperty(freObject, "hasAction", localNotification.hasAction);
		
		// Miscellaneous.
		localNotification.cancelOnSelect = ExtensionUtils.getBooleanProperty(freObject, "cancelOnSelect", localNotification.cancelOnSelect);
		localNotification.repeatAlertUntilAcknowledged = ExtensionUtils.getBooleanProperty(freObject, "repeatAlertUntilAcknowledged", localNotification.repeatAlertUntilAcknowledged);
		localNotification.alertPolicy = ExtensionUtils.getStringProperty(freObject, "alertPolicy", localNotification.alertPolicy);
		localNotification.ongoing = ExtensionUtils.getBooleanProperty(freObject, "ongoing", localNotification.ongoing);
		
		// Action data.
		FREByteArray byteArray = (FREByteArray)freObject.getProperty("actionData");
		if (byteArray != null)
		{
			byteArray.acquire();
			ByteBuffer byteBuffer = byteArray.getBytes();
			byteArray.release();
	
			localNotification.actionData = new byte[byteBuffer.limit()];
			byteBuffer.get(localNotification.actionData);
		}
		else
		{
			localNotification.actionData = new byte[0];
		}
		
		return localNotification;
	}
	
	
	public void dispatchNotificationSelectedEvent()
	{
		dispatchStatusEventAsync(NOTIFICATION_SELECTED, STATUS);
	}
	
	
	private static int getIconResourceIdFromString(String iconType, FREContext freContext)
	{
		int resourceId = 0;
		
		if (freContext != null)
		{
			Map<String, Integer> iconTypeToResourceIdMap = new HashMap<String, Integer>();
			
			// IMPORTANT: These map directly to the constants in the NotificationIconType class in the ActionScript interface.
			
			iconTypeToResourceIdMap.put("alert", freContext.getResourceId("drawable.alert_icon"));
			iconTypeToResourceIdMap.put("document", freContext.getResourceId("drawable.document_icon"));
			iconTypeToResourceIdMap.put("error", freContext.getResourceId("drawable.error_icon"));
			iconTypeToResourceIdMap.put("flag", freContext.getResourceId("drawable.flag_icon"));
			iconTypeToResourceIdMap.put("info", freContext.getResourceId("drawable.info_icon"));
			iconTypeToResourceIdMap.put("message", freContext.getResourceId("drawable.message_icon"));
			
			resourceId = iconTypeToResourceIdMap.get(iconType);
		}
		
		return resourceId;
	}
}

