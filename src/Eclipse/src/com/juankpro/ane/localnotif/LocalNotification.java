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


import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.util.Log;


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
	
	public String soundName = "";

	// Action.
	public boolean hasAction = true;
	public byte[] actionData = {};
	
	public Date fireDate = new Date();
	public int repeatInterval = 0;
	
	String activityClassName = "";
	
	
	/** The activityClassName parameter can be null if you expect to call deserialize to retrieve it afterward. */
	public LocalNotification(String activityClassName)
	{
		this.activityClassName = activityClassName;
	}
	
	
	public void serialize(SharedPreferences prefs)
	{
		Editor editor = prefs.edit();
		
		JSONObject jsonObject = new JSONObject();
		
		try
		{
			jsonObject.putOpt("code", code);
			jsonObject.putOpt("tickerText", tickerText);
			jsonObject.putOpt("title", title);
			jsonObject.putOpt("body", body);
			jsonObject.putOpt("playSound", playSound);
			jsonObject.putOpt("vibrate", vibrate);
			jsonObject.putOpt("iconResourceId", iconResourceId);
			jsonObject.putOpt("numberAnnotation", numberAnnotation);
			jsonObject.putOpt("cancelOnSelect", cancelOnSelect);
			jsonObject.putOpt("repeatAlertUntilAcknowledged", repeatAlertUntilAcknowledged);
			jsonObject.putOpt("ongoing", ongoing);
			jsonObject.putOpt("alertPolicy", alertPolicy);
			jsonObject.putOpt("hasAction", hasAction);
			jsonObject.putOpt("soundName", soundName);
			jsonObject.putOpt("fireDate", fireDate);
			jsonObject.putOpt("repeatInterval", repeatInterval);
			jsonObject.putOpt("activityClassName", activityClassName);
			
			// Action data.
			for (int i = 0; i < actionData.length; i++)
			{
				jsonObject.accumulate("actionData", (int)actionData[i]);
			}
		}
		catch(Exception e)
		{
			Log.d("LocalNotification::serialize", "Exception");
		}
				
		
		// Basic properties.
		editor.putString(code, jsonObject.toString());
		editor.commit();
	}

	
	public void deserialize(SharedPreferences prefs)
	{
		String jsonString = prefs.getString(code, "");
		JSONObject jsonObject = null;
		
		try
		{
			jsonObject = new JSONObject(jsonString);
		}
		catch(Exception e)
		{
			Log.d("LocalNotification::deserialize", "No valid JSON string Exception");
		}
		
		if(jsonObject != null)
		{
			// Note: using the current value as the default value in each case.
			code = jsonObject.optString("code", code);
			tickerText = jsonObject.optString("tickerText", tickerText);
			title = jsonObject.optString("title", title);
			body = jsonObject.optString("body", body);
			playSound = jsonObject.optBoolean("playSound", playSound);
			vibrate = jsonObject.optBoolean("vibrate", vibrate);
			iconResourceId = jsonObject.optInt("iconResourceId", iconResourceId);
			numberAnnotation = jsonObject.optInt("numberAnnotation", numberAnnotation);
			cancelOnSelect = jsonObject.optBoolean("cancelOnSelect", cancelOnSelect);
			repeatAlertUntilAcknowledged = jsonObject.optBoolean("repeatAlertUntilAcknowledged", repeatAlertUntilAcknowledged);
			ongoing = jsonObject.optBoolean("ongoing", ongoing);
			alertPolicy = jsonObject.optString("alertPolicy", alertPolicy);
			hasAction = jsonObject.optBoolean("hasAction", hasAction);
			soundName = jsonObject.optString("soundName", soundName);
			activityClassName = jsonObject.optString("activityClassName", activityClassName);
		
			long dateTime = jsonObject.optLong("fireDate", fireDate.getTime());
		
			fireDate = new Date(dateTime);
			repeatInterval = jsonObject.optInt("repeatInterval", repeatInterval);
			
			try
			{
				JSONArray jsonArray = jsonObject.getJSONArray("actionData");
				int dataLength = jsonArray.length();
				actionData = new byte[dataLength];
				for (int i = 0; i < dataLength; i++)
				{
					actionData[i] = (byte)jsonArray.getInt(i);
				}
			}
			catch(Exception e)
			{
				Log.d("LocalNotification::deserialize", "Exception while reading actionData");
			}
		}
	}
}

