package com.juankpro.ane.localnotif;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

/**
 * Created by Juank on 10/22/17.
 */

public class AlarmIntentService extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        Bundle bundle = intent.getExtras();
        String code = bundle.getString(Constants.NOTIFICATION_CODE_KEY);
        byte[] data = bundle.getByteArray(Constants.ACTION_DATA_KEY);

        boolean dispatched =
                new LocalNotificationDispatcher(code, data).dispatchInForeground();
        if (dispatched) { return; }

        AlarmHandler handler = new AlarmHandler(context, bundle);
        handler.postNotification();
        Logger.log("AlarmIntentService::onReceive Intent: " + intent.toString());
    }
}

