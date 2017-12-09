package com.juankpro.ane.localnotif;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.juankpro.ane.localnotif.factory.NotificationFactory;
import com.juankpro.ane.localnotif.factory.NotificationPendingIntentFactory;
import com.juankpro.ane.localnotif.util.Logger;

/**
 * Created by Juank on 10/22/17.
 */

public class AlarmIntentService extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        Bundle bundle = intent.getExtras();
        assert bundle != null;
        String code = bundle.getString(Constants.NOTIFICATION_CODE_KEY);
        boolean showInForeground = bundle.getBoolean(Constants.SHOW_IN_FOREGROUND);

        if (showInForeground) {
            sendNotification(code, context, bundle);
            return;
        }

        if (tryEventDispatch(code, bundle)) return;

        sendNotification(code, context, bundle);
        Logger.log("AlarmIntentService::onReceive Intent: " + intent.toString());
    }

    private boolean tryEventDispatch(String code, Bundle bundle) {
        byte[] data = bundle.getByteArray(Constants.ACTION_DATA_KEY);
        return new LocalNotificationEventDispatcher(code, data, null).dispatchWhenInForeground();
    }

    private void sendNotification(String code, Context context, Bundle bundle) {
        NotificationFactory notificationFactory = new NotificationFactory(context, bundle);
        NotificationPendingIntentFactory intentFactory = new NotificationPendingIntentFactory(context, bundle);
        Notification notification = notificationFactory.create(intentFactory);

        NotificationManager notificationManager = (NotificationManager)context
                .getSystemService(Context.NOTIFICATION_SERVICE);
        assert notificationManager != null;
        notificationManager.notify(code, Constants.STANDARD_NOTIFICATION_ID, notification);
    }
}

