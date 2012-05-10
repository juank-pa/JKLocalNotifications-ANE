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


import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;


public class LocalNotification
{	
	public String code = "";
	
	// Text.
	public String tickerText = "";
	public String title = "";
	public String body = "";
	
	// Sound.
	public boolean playSound = false;
	
	// Vibration.
	public boolean vibrate = false;
	
	// Icon.
	public int iconResourceId = 0;
	public int numberAnnotation = 0;
	
	// Miscellaneous.
	public boolean cancelOnSelect = false;
	public boolean repeatAlertUntilAcknowledged = false;
	public boolean ongoing = false;
	public String alertPolicy = "";

	// Action.
	public boolean hasAction = true;
	public byte[] actionData = {};
	
	String activityClassName = "";
	
	
	/** The activityClassName parameter can be null if you expect to call deserialize to retrieve it afterward. */
	public LocalNotification(String activityClassName)
	{
		this.activityClassName = activityClassName;
	}
	
	
	public void serialize(SharedPreferences prefs, String prefix)
	{
		Editor editor = prefs.edit();
		
		// Basic properties.
		editor.putString(prefix + "code", code);
		editor.putString(prefix + "tickerText", tickerText);
		editor.putString(prefix + "title", title);
		editor.putString(prefix + "body", body);
		editor.putBoolean(prefix + "playSound", playSound);
		editor.putBoolean(prefix + "vibrate", vibrate);
		editor.putInt(prefix + "iconResourceId", iconResourceId);
		editor.putInt(prefix + "numberAnnotation", numberAnnotation);
		editor.putBoolean(prefix + "cancelOnSelect", cancelOnSelect);
		editor.putBoolean(prefix + "repeatAlertUntilAcknowledged", repeatAlertUntilAcknowledged);
		editor.putBoolean(prefix + "ongoing", ongoing);
		editor.putString(prefix + "alertPolicy", alertPolicy);
		editor.putBoolean(prefix + "hasAction", hasAction);
		
		// Action data.
		editor.putInt(prefix + "actionDataLength", actionData.length);
		for (int i = 0; i < actionData.length; i++)
		{
			editor.putInt(prefix + "actionData" + i, actionData[i]);
		}
		
		editor.putString(prefix + "activityClassName", activityClassName);
		
		editor.commit();
	}

	
	public void deserialize(SharedPreferences prefs, String prefix)
	{
		// Note: using the current value as the default value in each case.
		code = prefs.getString(prefix + "code", code);
		tickerText = prefs.getString(prefix + "tickerText", tickerText);
		title = prefs.getString(prefix + "title", title);
		body = prefs.getString(prefix + "body", body);
		playSound = prefs.getBoolean(prefix + "playSound", playSound);
		vibrate = prefs.getBoolean(prefix + "vibrate", vibrate);
		iconResourceId = prefs.getInt(prefix + "iconResourceId", iconResourceId);
		numberAnnotation = prefs.getInt(prefix + "numberAnnotation", numberAnnotation);
		cancelOnSelect = prefs.getBoolean(prefix + "cancelOnSelect", cancelOnSelect);
		repeatAlertUntilAcknowledged = prefs.getBoolean(prefix + "repeatAlertUntilAcknowledged", repeatAlertUntilAcknowledged);
		ongoing = prefs.getBoolean(prefix + "ongoing", ongoing);
		alertPolicy = prefs.getString(prefix + "alertPolicy", alertPolicy);
		hasAction = prefs.getBoolean(prefix + "hasAction", hasAction);
		
		int actionDataLength = prefs.getInt(prefix + "actionDataLength", 0);
		actionData = new byte[actionDataLength];
		for (int i = 0; i < actionDataLength; i++)
		{
			actionData[i] = (byte)prefs.getInt(prefix + "actionData" + i, 0);
		}
		
		activityClassName = prefs.getString(prefix + "activityClassName", activityClassName);
	}
}

