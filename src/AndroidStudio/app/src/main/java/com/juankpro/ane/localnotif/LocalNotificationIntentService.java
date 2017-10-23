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
import android.app.ActivityManager.RunningAppProcessInfo;
import android.app.IntentService;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class LocalNotificationIntentService extends IntentService {
    public LocalNotificationIntentService() {
        super("com.juankpro.ane.localnotif.LocalNotificationIntentService");
    }

    @Override
    public final void onHandleIntent(Intent intent) {
        Context context = getApplicationContext();

        String code = intent.getStringExtra(Constants.NOTIFICATION_CODE_KEY);
        byte[] data = intent.getByteArrayExtra(Constants.ACTION_DATA_KEY);
        new LocalNotificationDispatcher(context, code, data).dispatchInBackground();

        // If the app is not running, or it's running, but in the background, start it by bringing it to the foreground or launching it.
        // The OS will handle what happens correctly.
        if(!ApplicationStatus.getInForeground()) {
            bringActivityToForeground(context, intent);
        }

        logStatus(intent);
    }

    private void bringActivityToForeground(Context context, Intent intent) {
        Intent newIntent = new Intent();
        newIntent.setClassName(context, intent.getStringExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY));
        newIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(newIntent);
    }

    private void logStatus(Intent intent) {
        if(ApplicationStatus.getActive()) {
            Logger.log("LocalNotificationIntentService::onHandleIntent App is running in foreground");
        } else {
            Logger.log("LocalNotificationIntentService::onHandleIntent App is running in background or not running");
        }
        Logger.log("LocalNotificationIntentService::onHandleIntent Intent: " + intent.toString());
    }
}

