package com.juankpro.ane.localnotif;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.RemoteInput;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;

import com.juankpro.ane.localnotif.factory.NotificationRequestIntentFactory;
import com.juankpro.ane.localnotif.util.Logger;
import com.juankpro.ane.localnotif.util.PersistenceManager;

import java.util.Date;

public class TextInputActionIntentService extends BroadcastReceiver {
    @SuppressWarnings("ConstantConditions")
    @Override
    public void onReceive(Context context, Intent intent) {
        String code = intent.getStringExtra(Constants.NOTIFICATION_CODE_KEY);

        PersistenceManager persistenceManager = new PersistenceManager(context);
        LocalNotification localNotification = persistenceManager.readNotification(code);

        Intent notificationIntent = new NotificationRequestIntentFactory(context)
                .createIntent(localNotification)
                .setClass(context, LocalNotificationIntentService.class)
                .putExtra(Constants.VIBRATE, false)
                .putExtra(Constants.PLAY_SOUND, false)
                .putExtra(Constants.PRIORITY, Notification.PRIORITY_DEFAULT)
                .putExtras(intent.getExtras());

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            Bundle bundle = RemoteInput.getResultsFromIntent(intent);
            String userResponse = bundle.getString(Constants.USER_RESPONSE_KEY);
            notificationIntent.putExtra(Constants.USER_RESPONSE_KEY, userResponse);
        }

        context.startService(notificationIntent);
    }
}
