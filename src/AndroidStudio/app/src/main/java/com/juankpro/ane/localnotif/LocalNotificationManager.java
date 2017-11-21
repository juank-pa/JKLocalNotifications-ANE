package com.juankpro.ane.localnotif;

import android.app.AlarmManager;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;

import com.juankpro.ane.localnotif.util.Logger;
import com.juankpro.ane.localnotif.util.PersistenceManager;

/**
 * Created by Juank on 10/21/17.
 */

class LocalNotificationManager {
    private Context context;
    private NotificationManager notificationManager;

    LocalNotificationManager(Context context) {
        this.context = context;
        notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
    }

    void notify(LocalNotification localNotification) {
        long notificationTime = localNotification.fireDate.getTime();
        PendingIntent pendingIntent = PendingIntent.getBroadcast(
                context,
                localNotification.code.hashCode(),
                getIntent(localNotification),
                PendingIntent.FLAG_CANCEL_CURRENT);
        long repeatInterval = new LocalNotificationTimeInterval(localNotification.repeatInterval)
                .toMilliseconds();

        AlarmManager am = getAlarmManager();

        if (repeatInterval != 0) {
            am.setRepeating(AlarmManager.RTC_WAKEUP, notificationTime, repeatInterval, pendingIntent);
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

    private Intent getIntent(LocalNotification localNotification) {
        final Intent intent = new Intent(context, AlarmIntentService.class);

        intent.setAction(localNotification.code);
        intent.putExtra(Constants.TITLE, localNotification.title);
        intent.putExtra(Constants.BODY, localNotification.body);
        intent.putExtra(Constants.TICKER_TEXT, localNotification.tickerText);
        intent.putExtra(Constants.NOTIFICATION_CODE_KEY, localNotification.code);
        intent.putExtra(Constants.ICON_RESOURCE, localNotification.iconResourceId);
        intent.putExtra(Constants.NUMBER_ANNOTATION, localNotification.numberAnnotation);
        intent.putExtra(Constants.PLAY_SOUND, localNotification.playSound);
        intent.putExtra(Constants.SOUND_NAME, localNotification.soundName);
        intent.putExtra(Constants.VIBRATE, localNotification.vibrate);
        intent.putExtra(Constants.CANCEL_ON_SELECT, localNotification.cancelOnSelect);
        intent.putExtra(Constants.ON_GOING, localNotification.ongoing);
        intent.putExtra(Constants.ALERT_POLICY, localNotification.alertPolicy);
        intent.putExtra(Constants.HAS_ACTION, localNotification.hasAction);
        intent.putExtra(Constants.ACTION_DATA_KEY, localNotification.actionData);
        intent.putExtra(Constants.PRIORITY, localNotification.priority);
        intent.putExtra(Constants.SHOW_IN_FOREGROUND, localNotification.showInForeground);
        intent.putExtra(Constants.CATEGORY, localNotification.category);

        if (localNotification.hasAction) {
            intent.putExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY, localNotification.activityClassName);
        }

        return intent;
    }
}

