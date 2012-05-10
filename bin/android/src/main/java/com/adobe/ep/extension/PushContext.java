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

package com.adobe.ep.extension;

import java.util.HashMap;
import java.util.Map;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import com.adobe.ep.localnotifications.LocalNotification;
import com.adobe.ep.localnotifications.LocalNotificationManager;
import com.adobe.ep.push.c2dm.C2DMEventHandler;
import com.adobe.ep.push.c2dm.C2DMPush;
import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class PushContext extends FREContext
{
	static final String extensionId = "PushContext";
	private static final String WAKE_UP_NOTIFICATION_CODE = "_ADOBE_wakeUpNotification_";
	private static final String QUEUE_PREFERENCE = "com.adobe.ep.push.queue";
	private static final String TAG = "PushContext";
	private static PushContext instance = null;

	PushContext()
	{
		instance = this;
		Log.d(TAG, "PushContext " + instance);
	}

	@Override
	public void dispose()
	{
		instance = null;
		Log.d(TAG, "dispose");
	}

	@Override
	public Map<String, FREFunction> getFunctions()
	{
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();

		functionMap.put("register", new FunctionHelper() {

			// passedArgs[0] PushRegistrationSettings: (supplied by AS client code)
			// passedArgs[1] applicationID
			// passedArgs[2] clientAppsAPIURL
			// passedArgs[3] Android-only, property names of the PushRegistrationSettings.androidWakeUpNotifications

			@Override
			public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception
			{
				Log.d(TAG, "register");

				// IMPORTANT: These property names must match the names in the PushRegistrationSettings class exactly.

				String authenticationToken = passedArgs[0].getProperty("authenticationToken").getAsString();
				String applicationID = passedArgs[1].getAsString();
				String clientAppsAPIURL = passedArgs[2].getAsString();
				Log.d(TAG, "args: " + clientAppsAPIURL + ", " + applicationID);

				final SharedPreferences prefs = getQueueSharedPreferences(context.getActivity().getApplicationContext());
				FREObject awnObject = passedArgs[0].getProperty("androidWakeUpNotifications");

				if (awnObject != null)
				{
					// The ActionScript side prepared a list of all the dynamic property names of the androidWakeUpNotifications object.
					FREArray awnPropertyNames = (FREArray) passedArgs[3];
					for (long i = 0; i < awnPropertyNames.getLength(); i++)
					{
						String propertyName = awnPropertyNames.getObjectAt(i).getAsString();
						FREObject awnNotification = awnObject.getProperty(propertyName);

						// Get and store the wake-up notifications for some time later when we're not running.
						LocalNotification notification = LocalNotificationsContext.decodeLocalNotification(WAKE_UP_NOTIFICATION_CODE, awnNotification, context);
						notification.serialize(prefs, propertyName);
					}
				}
				else
				{
					prefs.edit().clear().commit();
				}

				C2DMPush.RegistrationSettings settings = new C2DMPush.RegistrationSettings();

				settings.clientAppsAPIURL = clientAppsAPIURL;
				settings.applicationId = applicationID;
				settings.authenticationToken = authenticationToken;
				settings.eventHandlerClassName = GlueEventHandler.class.getName();
				C2DMPush.getInstance().register(getActivity().getApplicationContext(), settings);
				GlueEventHandler.checkForQueuedMessages(getActivity());
				return FREObject.newObject("initialized!");
			}
		});
		functionMap.put("unregister", new FunctionHelper() {
			@Override
			public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception
			{
				Log.d(TAG, "unregister");
				C2DMPush.getInstance().unregister(getActivity().getApplicationContext());
				return FREObject.newObject("unregistered!");
			}
		});
		functionMap.put("getMessageType", new FunctionHelper() {
			@Override
			public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception
			{
				Log.d(TAG, "getMessageType");
				String data = GlueEventHandler.lastMessageType;
				GlueEventHandler.lastMessageType = "";
				return FREObject.newObject(data);
			}
		});
		functionMap.put("getMessageBody", new FunctionHelper() {
			@Override
			public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception
			{
				Log.d(TAG, "getMessageBody");
				String data = GlueEventHandler.lastMessageBody;
				GlueEventHandler.lastMessageBody = "";
				return FREObject.newObject(data);
			}
		});
		functionMap.put("getDebugText", new FunctionHelper() {
			@Override
			public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception
			{
				Log.d(TAG, "getDebugText");
				String data = GlueEventHandler.lastDebugText;
				GlueEventHandler.lastDebugText = "";
				return FREObject.newObject(data);
			}
		});

		return functionMap;
	}

	static SharedPreferences getQueueSharedPreferences(Context context)
	{
		return context.getSharedPreferences(QUEUE_PREFERENCE, Context.MODE_PRIVATE);
	}

	public static class GlueEventHandler extends C2DMEventHandler
	{
		private static final String LAST_MESSAGE_BODY = "lastMessageBody";
		private static final String LAST_MESSAGE_TYPE = "lastMessageType";
		private static String DATA_RECEIVED = "dataReceived";
		private static String STATUS = "status";
		private static String ERROR = "error";

		static String lastMessageType = ""; // TODO do something less crude.
		static String lastMessageBody = ""; // TODO do something less crude.
		static String lastDebugText = "";

		/** Map of Android ERROR_* and STATE_* values to those for ActionScript. */
		private Map<String, String> codeMap = new HashMap<String, String>();

		public GlueEventHandler()
		{
			// IMPORTANT: These must map all error and state codes to the codes in PushDispatcher.

			codeMap.put(ERROR_CANNOT_GET_REGISTRATION_ID, "errorCannotGetRegistrationID");
			codeMap.put(ERROR_CANNOT_SELF_REGISTER, "errorCannotSelfRegister");
			codeMap.put(STATE_UNREGISTERED, "stateUnregistered");
			codeMap.put(STATE_COMPLETED_REST_CALL, "stateCompletedRESTCall");
			codeMap.put(STATE_RECEIVED_C2DM_REG_ID, "stateReceivedRegistrationID");
			codeMap.put(STATE_SELF_REGISTERED, "stateSelfRegistered");
		}

		@Override
		public void onReceive(Context context, String messageType, String messageBody)
		{
			Log.d(TAG, messageType + "/" + messageBody);
			lastMessageType = messageType;
			lastMessageBody = messageBody;
			if (instance != null)
			{
				instance.dispatchStatusEventAsync(DATA_RECEIVED, STATUS);
			}
			else
			{
				Log.d(TAG, "instance null, queuing");
				final SharedPreferences prefs = getQueueSharedPreferences(context);
				prefs.edit().putString(LAST_MESSAGE_TYPE, lastMessageType).putString(LAST_MESSAGE_BODY, lastMessageBody).commit();

				// Fire a notification that will start the application when clicked.
				LocalNotification localNotification = new LocalNotification(null);
				// Attempt to find a notification matching messageType exactly.
				localNotification.deserialize(prefs, messageType);
				// If the default values were retrieved, then name will be empty rather than WAKE_UP_NOTIFICATION_NAME.
				if (!localNotification.code.equals(WAKE_UP_NOTIFICATION_CODE))
				{
					// No exact match on messageType. Attempt to find a notification matching "*".
					Log.i(TAG, "No exact match for messageType.  Checking for '*'.");
					localNotification.deserialize(prefs, "*");
				}
				if (localNotification.code.equals(WAKE_UP_NOTIFICATION_CODE))
				{
					Log.i(TAG, "issuing wake-up notification");
					new LocalNotificationManager(context).notify(localNotification);
				}
			}

		}

		@Override
		public void onError(Context context, String errorId, String debugText)
		{
			Log.e(TAG, "onError: " + errorId + " " + debugText);
			lastDebugText = debugText;
			if (instance != null)
			{
				instance.dispatchStatusEventAsync(remapCode(errorId), ERROR);
			}
			else
			{
				Log.w(TAG, "instance null; not dispatching error event");
			}
		}

		@Override
		public void onStateChange(Context context, String newState)
		{
			if (instance != null)
			{
				instance.dispatchStatusEventAsync(remapCode(newState), STATUS);
			}
			else
			{
				Log.w(TAG, "instance null; not dispatching status event");
			}
		}

		private String remapCode(String code)
		{
			String remappedCode = codeMap.get(code);
			if (remappedCode == null)
			{
				Log.e(TAG, "Internal error.  No mapping for code: " + code);
				remappedCode = code;
			}
			return remappedCode;
		}

		static void checkForQueuedMessages(Context context)
		{
			Log.w(TAG, "checkForQueuedMessages");
			final SharedPreferences prefs = getQueueSharedPreferences(context);
			lastMessageType = prefs.getString(LAST_MESSAGE_TYPE, "");
			lastMessageBody = prefs.getString(LAST_MESSAGE_BODY, "");
			if (lastMessageType.length() > 0 && lastMessageBody.length() > 0)
			{
				Log.w(TAG, "checkForQueuedMessages dispatching " + lastMessageType);
				prefs.edit().remove(LAST_MESSAGE_TYPE).remove(LAST_MESSAGE_BODY).commit();
				instance.dispatchStatusEventAsync(DATA_RECEIVED, STATUS);
			}
		}
	}
}
