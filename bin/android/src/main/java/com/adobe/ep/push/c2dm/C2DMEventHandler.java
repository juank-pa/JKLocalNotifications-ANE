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

import android.content.Context;
import android.util.Log;

import com.adobe.ep.push.c2dm.C2DMPush.RegistrationSettings;

/**
 * The C2DMEventHandler class handles all push events, including received data (onReceive), errors (onError), and changes in state (onStateChange). Override any or
 * all of these methods to provide custom behaviour. The name of your derived class is passed as the eventHandlerClassName member of
 * {@link RegistrationSettings} .
 */
public class C2DMEventHandler
{
	private static final String TAG = "C2DMEventHandler";

	/** Unable to get a registration ID from the cloud. This may be due to incorrect permissions, or may be a transient failure. */
	public static final String ERROR_CANNOT_GET_REGISTRATION_ID = "CANNOT_GET_REGISTRATION_ID";
	/** Unable to register with the CRX server. It may be unreachable or not configured correctly. */
	public static final String ERROR_CANNOT_SELF_REGISTER = "CANNOT_SELF_REGISTER";

	/** In initial state. */
	public static final String STATE_UNREGISTERED = "UNREGISTERED";
	/** Made a successful initial call to REST endpoint. Will automatically attempt to get a registration ID from the cloud. */
	public static final String STATE_COMPLETED_REST_CALL = "COMPLETED_REST_CALL";
	/** Received a registration ID. Will automatically attempt to self-register with host CRX server next. */
	public static final String STATE_RECEIVED_C2DM_REG_ID = "RECEIVED_C2DM_REG_ID";
	/** Successfully supplied registration ID to host CRX server. Can now receive messages from server. */
	public static final String STATE_SELF_REGISTERED = "SELF_REGISTERED";

	/**
	 * Override this method to receive push notifications. The default implementation logs the message type.
	 * 
	 * This method is invoked on a service thread, so no UI is permitted.
	 * 
	 * @param context
	 *            The Context this is associated with.
	 * @param messageType
	 *            the message type of this notification. The string is transmitted to clients to identify the contents. Clients may receive more than one type
	 *            of message, and can use this identifier to distinguish between them.
	 * @param messageBody
	 *            the content of this notification. The sender and the client must agree upon the meaning of the data.
	 */
	public void onReceive(Context context, String messageType, String messageBody)
	{
		Log.i(TAG, "onReceive: " + messageType);
	}

	/**
	 * Override this method to handle errors. The default implementation logs the error.
	 * 
	 * This method is invoked on a service thread, so no UI is permitted.
	 * 
	 * @param context
	 *            The Context this is associated with.
	 * @param errorId
	 *            one of the ERROR_* constants listed above. It is safe to test for object equality, eg if (errorId ==
	 *            C2DMEventHandler.ERROR_CANNOT_SELF_REGISTER)...
	 * @param debugText
	 *            text that may be useful in debugging.
	 */
	public void onError(Context context, String errorId, String debugText)
	{
		Log.e(TAG, "onError: " + errorId + " " + debugText);
	}

	/**
	 * Override this method to monitor changes in state. The default implementation logs the state change.
	 * 
	 * This method is invoked on a service thread, so no UI is permitted.
	 * 
	 * @param context
	 *            The Context this is associated with.
	 * @param newState
	 *            one of the STATE_* constants listed above. It is safe to test for object equality, eg if (newState == C2DMEventHandler.STATE_SELF_REGISTERED)...
	 */
	public void onStateChange(Context context, String newState)
	{
		Log.i(TAG, "onStateChange: " + newState);
	}
}
