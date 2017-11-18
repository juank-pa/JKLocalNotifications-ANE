package com.juankpro.ane.localnotif;

import java.util.Map;
import java.util.Set;

import android.app.AlarmManager;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

/**
 * Created by Juank on 10/21/17.
 */

class LocalNotificationManager {
    private final static String ANE_NAME = "JK_ANE_LocalNotification";

    private Context androidContext;
    private NotificationManager notificationManager;

    LocalNotificationManager(Context activity) {
        androidContext = activity.getApplicationContext();
        notificationManager = (NotificationManager)androidContext.getSystemService(Context.NOTIFICATION_SERVICE);

        Logger.log("LocalNotificationManager::initialize Called with activity: " + activity.toString());
    }

    void notify(LocalNotification localNotification) {
        // Time.
        long notificationTime = localNotification.fireDate.getTime();

        final Intent intent = new Intent(androidContext, AlarmIntentService.class);

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

        Logger.log("LocalNotificationManager when:" + String.valueOf(notificationTime) + ", current:" + System.currentTimeMillis());

        // If a notification is specified to have an action, set up the intent to launch the app when the notification is selected by a user.
        if (localNotification.hasAction) {
            intent.putExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY, localNotification.activityClassName);
            Logger.log("LocalNotificationManager::notify Activity Class Name: " + localNotification.activityClassName);
        }

        final PendingIntent pendingIntent = PendingIntent.getBroadcast(androidContext, localNotification.code.hashCode(), intent, PendingIntent.FLAG_CANCEL_CURRENT);
        final AlarmManager am = getAlarmManager();

        NotificationTimeInterval interval = new NotificationTimeInterval(localNotification.repeatInterval);
        long repeatInterval = interval.toMilliseconds();

        if (repeatInterval != 0) {
            am.setRepeating(AlarmManager.RTC_WAKEUP, notificationTime, repeatInterval, pendingIntent);
        } else {
            am.set(AlarmManager.RTC_WAKEUP, notificationTime, pendingIntent);
        }

        Logger.log("LocalNotificationManager::notify Called with notification code: " + localNotification.code);
    }

    void cancel(String notificationCode) {
        /*
		 * Create an intent that looks similar, to the one that was registered
		 * using add. Making sure the notification id in the action is the same.
		 * Now we can search for such an intent using the 'getService' method
		 * and cancel it.
		 */
        final Intent intent = new Intent(androidContext, AlarmIntentService.class);
        intent.setAction(notificationCode);

        final PendingIntent pi = PendingIntent.getBroadcast(androidContext, notificationCode.hashCode(), intent, PendingIntent.FLAG_CANCEL_CURRENT);
        final AlarmManager am = getAlarmManager();

        try {
            am.cancel(pi);
            Logger.log("LocalNotificationManager::cancel Called with notification code: " + notificationCode);
        } catch (Exception e) {
            Logger.log("LocalNotificationManager::cancel Exception: " + e.getMessage());
        }

        notificationManager.cancel(notificationCode, Constants.STANDARD_NOTIFICATION_ID);
    }

    private AlarmManager getAlarmManager() {
        return (AlarmManager) androidContext.getSystemService(Context.ALARM_SERVICE);
    }

    void cancelAll() {
        final SharedPreferences alarmSettings = androidContext.getSharedPreferences(ANE_NAME, Context.MODE_PRIVATE);

        final Map<String, ?> allAlarms = alarmSettings.getAll();
        final Set<String> alarmIds = allAlarms.keySet();

        for (String alarmId : alarmIds) {
            Logger.log(ANE_NAME + "Canceling notification with id: " + alarmId);
            cancel(alarmId);
        }

        notificationManager.cancelAll();
        Logger.log("LocalNotificationManager::cancelAll Called");
    }

    /**
     * Persist the information of this notification to the Android Shared Preferences.
     * This will allow the application to restore the alarm upon device reboot.
     * Also this is used by the cancelAllNotifications method.
     *
     * @param notification The notification to persist.
     * @see #cancelAll()
     */
    void persistNotification(LocalNotification notification) {
        Logger.log("LocalNotificationManager::persistNotification Notification: " + notification.code);
        final SharedPreferences alarmSettings = androidContext.getSharedPreferences(ANE_NAME, Context.MODE_PRIVATE);
        notification.serialize(alarmSettings);
    }

    /**
     * Remove a specific notification from the Android shared Preferences
     *
     * @param notificationCode The notification to persist.
     */
    void unpersistNotification(String notificationCode) {
        Logger.log("LocalNotificationManager::unpersistNotification Notification: " + notificationCode);
        final Editor alarmSettingsEditor = androidContext.getSharedPreferences(ANE_NAME, Context.MODE_PRIVATE).edit();
        alarmSettingsEditor.remove(notificationCode);
        alarmSettingsEditor.apply();
    }

    /**
     * Clear all notifications from the Android shared Preferences
     */
    void unpersistAllNotifications() {
        Logger.log("LocalNotificationManager::unpersistAllNotifications Called");
        final Editor alarmSettingsEditor = androidContext.getSharedPreferences(ANE_NAME, Context.MODE_PRIVATE).edit();
        alarmSettingsEditor.clear();
        alarmSettingsEditor.apply();
    }
}

