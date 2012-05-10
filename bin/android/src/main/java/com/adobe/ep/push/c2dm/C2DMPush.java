/*
 * ADOBE CONFIDENTIAL
 *
 * Copyright 2011 Adobe Systems Incorporated
 * All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and may be covered by U.S. and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 *
 */
package com.adobe.ep.push.c2dm;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Build;
import android.util.Log;

import com.adobe.ep.push.Push;
//import com.adobe.ep.security.crypto.android.AndroidCryptoSupport;
import com.google.android.c2dm.C2DMessaging;

/**
 * The C2DMPush class contains methods related to management of the Push mechanism. It's a central hub for initializing and configuring the system. Obtain an
 * instance via C2DMPush.getInstance().
 */
public class C2DMPush extends Push
{
	private static final String TAG = "C2DMPush";
	private static final String PROVIDER_ID = "c2dm";

	private static final String PREFERENCE = "com.adobe.ep.push";
	private static final String PREFERENCE_EVENT_HANDLER_CLASS_NAME = "EVENT_HANDLER_CLASS_NAME"; // C2DMEventHandler-derived class
	private static final String PREFERENCE_SENDER_ID = "SENDER_ID";

	private static C2DMPush instance;

	private C2DMEventHandler eventHandlerInstance;
	/** Map of Push.ERROR_* and Push.STATE_* values to those for C2DMEventHandler. */
	private Map<String, String> codeMap = new HashMap<String, String>();

	// Construct only via getInstance().
	private C2DMPush()
	{
		super(PROVIDER_ID);
		codeMap.put(ERROR_CANNOT_GET_REGISTRATION_ID, C2DMEventHandler.ERROR_CANNOT_GET_REGISTRATION_ID);
		codeMap.put(ERROR_CANNOT_SELF_REGISTER, C2DMEventHandler.ERROR_CANNOT_SELF_REGISTER);
		codeMap.put(STATE_UNREGISTERED, C2DMEventHandler.STATE_UNREGISTERED);
		codeMap.put(STATE_COMPLETED_REST_CALL, C2DMEventHandler.STATE_COMPLETED_REST_CALL);
		codeMap.put(STATE_RECEIVED_REG_ID, C2DMEventHandler.STATE_RECEIVED_C2DM_REG_ID);
		codeMap.put(STATE_SELF_REGISTERED, C2DMEventHandler.STATE_SELF_REGISTERED);
	}

	/**
	 * Return the single instance of a C2DMPush object.
	 * 
	 * @return the C2DMPush singleton.
	 */
	public static C2DMPush getInstance()
	{
		if (instance == null)
		{
			instance = new C2DMPush();
		}
		return instance;
	}

	/**
	 * Register for push notifications.
	 * 
	 * @param context
	 *            the application's Context. The client typically passes 'this' from their main Activity.
	 * @param registrationSettings
	 *            an instance of the {@link RegistrationSettings} class that specifies configuration details. See that class for details.
	 */
	public void register(Context context, RegistrationSettings registrationSettings)
	{
		// C2DM messaging requires FROYO
		if (Build.VERSION.SDK_INT < Build.VERSION_CODES.FROYO)
			throw new IllegalStateException("C2DM messaging requires FROYO");
		eventHandlerInstance = null;
		transientContext = context;
		Log.i(TAG, "register called");
		registrationSettings.validate();

		setPreference(PREFERENCE_EVENT_HANDLER_CLASS_NAME, registrationSettings.eventHandlerClassName);
		super.register(registrationSettings);
	}

	/**
	 * Unregister for push notifications. Most applications will not need to do this.
	 * 
	 * @param context
	 *            the application's Context. The client typically passes 'this' from their main Activity.
	 */
	public void unregister(Context context)
	{
		transientContext = context;
		eventHandlerInstance = null;
		super.unregister();
		C2DMessaging.unregister(context);
	}

	/** Called from C2DMReceiver */
	void onMessage(Context context, Intent intent)
	{
		transientContext = context;
		String messageType = intent.getStringExtra("mt");
		String messageBody = intent.getStringExtra("mb");
		Log.i(TAG, "message type: '" + messageType + "'.");
		if (messageType != null && messageBody != null)
		{
			getEventHandlerInstance().onReceive(context, messageType, messageBody);
		}
	}

	/** Called from C2DMReceiver */
	void onError(Context context, String debugText)
	{
		transientContext = context;
		onError(ERROR_CANNOT_GET_REGISTRATION_ID, debugText);
	}

	/** Called from C2DMReceiver */
	final protected void onRegistered(Context context, String registrationId)
	{
		transientContext = context;
		super.onRegistered(registrationId);
	}

	/** Called from C2DMReceiver */
	final protected void onUnregistered(Context context)
	{
		transientContext = context;
		super.onUnregistered();
	}

	final protected String getDeviceId()
	{
		//return new AndroidCryptoSupport(getContext()).getDeviceId();
		return "";
	}

	private C2DMEventHandler getEventHandlerInstance()
	{
		if (eventHandlerInstance == null)
		{
			// Create class from stored class name.
			String className = getPreference(PREFERENCE_EVENT_HANDLER_CLASS_NAME, C2DMEventHandler.class.getName());
			eventHandlerInstance = (C2DMEventHandler) constructClassInstance(className, C2DMEventHandler.class);
		}
		return eventHandlerInstance;
	}

	private static Object constructClassInstance(String className, Class<?> derivedFromclass)
	{
		Object instance = null;
		try
		{
			Class<?> clz = Class.forName(className);
			instance = clz.newInstance();
		} catch (ClassNotFoundException e)
		{
			Log.e(TAG, "derived class must be in class path.", e);
		} catch (InstantiationException e)
		{
			Log.e(TAG, "derived class must be concrete.", e);
		} catch (IllegalAccessException e)
		{
			Log.e(TAG, "derived class must have a no-argument constructor.", e);
		}
		if (!derivedFromclass.isInstance(instance))
		{
			Log.e(TAG, "Invalid class: '" + className + "' is not derived from class '" + derivedFromclass.getName() + "'");
			instance = null;
		}
		if (instance == null)
		{
			throw new IllegalStateException();
		}
		return instance;
	}

	@Override
	final protected void onError(String errorId, String debugText)
	{
		getEventHandlerInstance().onError(getContext(), remapCode(errorId), debugText);
	}

	@Override
	final protected void onStateChange(String newState)
	{
		getEventHandlerInstance().onStateChange(getContext(), remapCode(newState));
	}

	@Override
	final protected void clearAllPreferences()
	{
		final SharedPreferences prefs = getContext().getSharedPreferences(PREFERENCE, Context.MODE_PRIVATE);
		Editor editor = prefs.edit();
		for (String key : prefs.getAll().keySet())
		{
			editor.putString(key, null);
		}
		editor.commit();
	}

	@Override
	final protected void setPreference(String key, String value)
	{
		final SharedPreferences prefs = getContext().getSharedPreferences(PREFERENCE, Context.MODE_PRIVATE);
		Editor editor = prefs.edit();
		editor.putString(key, value);
		editor.commit();
	}

	@Override
	final protected String getPreference(String key, String defaultValue)
	{
		final SharedPreferences prefs = getContext().getSharedPreferences(PREFERENCE, Context.MODE_PRIVATE);
		return prefs.getString(key, defaultValue);
	}

	@Override
	final protected void log(char logLevel, String string)
	{
		switch (logLevel) {
		case LOG_INFO:
			Log.i(TAG, string);
			break;
		default:
			Log.e(TAG, string);
			break;
		}
	}

	@Override
	final protected void processMetadata(JSONObject jsonObject) throws Exception
	{
		String senderId = jsonObject.getString("senderId");
		setPreference(PREFERENCE_SENDER_ID, senderId);
	}

	@Override
	final protected void requestIdAsync()
	{
		C2DMessaging.register(getContext(), getPreference(PREFERENCE_SENDER_ID, ""));
	}

	@Override
	final protected String getRegistrationId()
	{
		return C2DMessaging.getRegistrationId(getContext());
	}

	private Context transientContext = null; // only populated during calls

	private Context getContext()
	{
		if (transientContext == null)
		{
			throw new IllegalStateException("Internal error: No context available!");
		}
		return transientContext;
	}

	/**
	 * Takes care of mapping the protected Push.STATE_* and Push.ERROR_* to the C2DMEventHandler equivalents.
	 * 
	 * @param code
	 *            the Push.STATE_* or Push.ERROR_* code.
	 * @return the remapped C2DMEventHandler code
	 */
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

	/**
	 * The RegistrationSettings class, which is passed to register().
	 */
	public static class RegistrationSettings extends Push.RegistrationSettings
	{
		// Properties are copied verbatim from Push.RegistrationSettings purely for the sake of clean javadocs.
		/**
		 * The application ID. An application with this ID must have already been configured on the server.
		 */
		public String applicationId;
		/**
		 * The client-apps API URL of the CRX server (eg. "http://my.server.com:4502/aep/clientapps/api.json"). The server must have the server-side Push
		 * component installed.
		 */
		public String clientAppsAPIURL;
		/**
		 * The authentication token. This property both identifies the logged-in user on the CRX system and authenticates that user. It must have been
		 * previously obtained via the security API or by some other means such as basic authentication.
		 */
		public String authenticationToken;

		/**
		 * The name of a client-supplied class that derives from {@link C2DMEventHandler}, typically provided as <code>MyEventHandler.class.getName()</code>.
		 * This parameter is optional and can be null, but that would mean that state-changes and error conditions would be ignored by the client.
		 */
		public String eventHandlerClassName;

		final protected void validate()
		{
			// Properties are copied verbatim from Push.RegistrationSettings purely for the sake of clean javadocs.
			super.applicationId = applicationId;
			super.clientAppsAPIURL = clientAppsAPIURL;
			super.authenticationToken = authenticationToken;
			super.validate();
			validateNotEmpty(eventHandlerClassName, "eventHandlerClassName");
		}
	}
}
