package com.juankpro.ane.localnotif;

import android.app.AlarmManager;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;

import com.juankpro.ane.localnotif.factory.NotificationRequestIntentFactory;
import com.juankpro.ane.localnotif.factory.NotificationStrategyFactory;
import com.juankpro.ane.localnotif.notifier.INotificationStrategy;
import com.juankpro.ane.localnotif.util.Logger;
import com.juankpro.ane.localnotif.util.NextNotificationCalculator;
import com.juankpro.ane.localnotif.util.PersistenceManager;

import java.util.Date;

/**
 * Created by Juank on 10/21/17.
 */

class LocalNotificationManager {
    private Context context;
    private NotificationManager notificationManager;
    private NotificationRequestIntentFactory intentFactory;
    private INotificationStrategy notifier;

    LocalNotificationManager(Context context) {
        this.context = context;
        intentFactory = new NotificationRequestIntentFactory(context);
        notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        notifier = new NotificationStrategyFactory(context).create();
    }

    void notify(LocalNotification notification) {
        NextNotificationCalculator calculator = new NextNotificationCalculator(notification);
        long notificationTime = calculator.getTime(new Date());

        PendingIntent pendingIntent = PendingIntent.getBroadcast(
                context,
                notification.code.hashCode(),
                intentFactory.createIntent(notification),
                PendingIntent.FLAG_CANCEL_CURRENT);
        long repeatInterval = notification.getRepeatIntervalMilliseconds();

        if (repeatInterval != 0) {
            notifier.notifyRepeating(notificationTime, repeatInterval, pendingIntent, notification);
        }
        else {
            notifier.notify(notificationTime, pendingIntent, notification);
        }
    }

    void cancel(String notificationCode) {
        final Intent intent = new Intent(context, AlarmIntentService.class);
        intent.setAction(notificationCode);

        final PendingIntent pi = PendingIntent.getBroadcast(context, notificationCode.hashCode(), intent, PendingIntent.FLAG_CANCEL_CURRENT);
        final AlarmManager am = getAlarmManager();

        try {
            am.cancel(pi);
        }
        catch (Exception e) {
            Logger.log("LocalNotificationManager::cancel Exception: " + e.getMessage());
        }
        finally {
            notificationManager.cancel(notificationCode, Constants.STANDARD_NOTIFICATION_ID);
        }
    }

    private AlarmManager getAlarmManager() {
        return (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
    }

    void cancelAll() {
        PersistenceManager persistenceManager = new PersistenceManager(context);
        for (String alarmId : persistenceManager.readNotificationKeys()) {
            cancel(alarmId);
        }
        notificationManager.cancelAll();
    }

}

