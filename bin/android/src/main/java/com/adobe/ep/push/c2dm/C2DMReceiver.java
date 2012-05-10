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
import android.content.Intent;

import com.google.android.c2dm.C2DMBaseReceiver;

/**
 * Internal class; not used directly in code. This is the IntentService that receives all C2DM messages. An entry in the manifest must identify this class as a
 * service, i.e.:
 * 
 * <pre>
 * &lt;service android:name="com.adobe.ep.push.c2dm.C2DMReceiver" /&gt;
 * </pre>
 */
public final class C2DMReceiver extends C2DMBaseReceiver
{
	public C2DMReceiver()
	{
		super("com.adobe.ep.push.c2dm.C2DMReceiver");
	}

	@Override
	protected void onMessage(Context context, Intent intent)
	{
		C2DMPush.getInstance().onMessage(context, intent);
	}

	@Override
	public void onError(Context context, String errorId)
	{
		C2DMPush.getInstance().onError(context, errorId);
	}

	@Override
	public void onRegistered(Context context, String registrationId)
	{
		C2DMPush.getInstance().onRegistered(context, registrationId);
	}

	@Override
	public void onUnregistered(Context context)
	{
		C2DMPush.getInstance().onUnregistered(context);
	}
}
