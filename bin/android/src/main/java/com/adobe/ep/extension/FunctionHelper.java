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

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

public abstract class FunctionHelper implements FREFunction
{
	public abstract FREObject invoke(FREContext context, FREObject[] passedArgs) throws Throwable;

	@Override
	public FREObject call(FREContext context, FREObject[] passedArgs)
	{
		FREObject result = null;

		try
		{
			result = invoke(context, passedArgs);
		} catch (Throwable e)
		{
			e.printStackTrace();
			Log.e("Unhandled exception", e.toString());
			try
			{
				result = FREObject.newObject("Exception! " + e);
			} catch (FREWrongThreadException wte)
			{
				wte.printStackTrace();
			}
		}
		return result;
	}
}
