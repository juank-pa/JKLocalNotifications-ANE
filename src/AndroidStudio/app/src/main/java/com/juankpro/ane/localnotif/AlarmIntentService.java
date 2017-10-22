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


import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

public class AlarmIntentService extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        Bundle bundle = intent.getExtras();
        String code = bundle.getString(Constants.NOTIFICATION_CODE_KEY);
        byte[] data = bundle.getByteArray(Constants.ACTION_DATA_KEY);
        boolean dispatched = new LocalNotificationDispatcher(context).attemptDispatch(code, data);

        if (dispatched) { return; }

        AlarmHandler handler = new AlarmHandler(context, bundle);
        handler.postNotification();
        Logger.log("AlarmIntentService::onReceive Intent: " + intent.toString());
    }
}

