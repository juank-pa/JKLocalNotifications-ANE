package com.juankpro.ane.localnotif;

import android.app.Notification;
import android.app.NotificationManager;
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

        if (tryEventDispatch(code, bundle)) return;

        sendNotification(code, context, bundle);
        Logger.log("AlarmIntentService::onReceive Intent: " + intent.toString());
    }

    private boolean tryEventDispatch(String code, Bundle bundle) {
        byte[] data = bundle.getByteArray(Constants.ACTION_DATA_KEY);
        return new LocalNotificationEventDispatcher(code, data).dispatchInForeground();
    }

    private void sendNotification(String code, Context context, Bundle bundle) {
        NotificationFactory notificationFactory = new NotificationFactory(context, bundle);
        NotificationIntentFactory intentFactory = new NotificationIntentFactory(context, bundle);
        Notification notification = notificationFactory.create(intentFactory);

        NotificationManager notificationManager = (NotificationManager)context
                .getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.notify(code, Constants.STANDARD_NOTIFICATION_ID, notification);
    }
}

