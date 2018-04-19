package com.juankpro.ane.localnotif;

import android.app.AlarmManager;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Build;

import com.juankpro.ane.localnotif.factory.NotificationRequestIntentFactory;
import com.juankpro.ane.localnotif.util.Logger;
import com.juankpro.ane.localnotif.util.PersistenceManager;

/**
 * Created by Juank on 10/21/17.
 */

class LocalNotificationManager {
    private Context context;
    private NotificationManager notificationManager;
    private NotificationRequestIntentFactory intentFactory;

    LocalNotificationManager(Context context) {
        this.context = context;
        intentFactory = new NotificationRequestIntentFactory(context);
        notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
    }

    void notify(LocalNotification localNotification) {
        long notificationTime = localNotification.fireDate.getTime();
        PendingIntent pendingIntent = PendingIntent.getBroadcast(
                context,
                localNotification.code.hashCode(),
                intentFactory.createIntent(localNotification),
                PendingIntent.FLAG_CANCEL_CURRENT);
        long repeatInterval = localNotification.getRepeatIntervalMilliseconds();

        if (repeatInterval != 0) {
            setRepeatingAlarm(notificationTime, repeatInterval, pendingIntent, localNotification.isExact);
        }
        else {
            setAlarm(notificationTime, pendingIntent, localNotification.isExact);
        }
    }

    private void setRepeatingAlarm(long notificationTime, long repeatInterval, PendingIntent pendingIntent, boolean isExact) {
        AlarmManager am = getAlarmManager();

        if (isExact) {
            setAlarm(notificationTime, pendingIntent, true);
        }
        else {
            am.setInexactRepeating(AlarmManager.RTC_WAKEUP, notificationTime, repeatInterval, pendingIntent);
        }
    }

    private void setAlarm(long notificationTime, PendingIntent pendingIntent, boolean isExact) {
        AlarmManager am = getAlarmManager();

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
            am.set(AlarmManager.RTC_WAKEUP, notificationTime, pendingIntent);
            return;
        }

        if (isExact) {
            am.setExact(AlarmManager.RTC_WAKEUP, notificationTime, pendingIntent);
        }
        else {
            am.set(AlarmManager.RTC_WAKEUP, notificationTime, pendingIntent);
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

