package com.juankpro.ane.localnotif.notifier;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;

import com.juankpro.ane.localnotif.LocalNotification;

public abstract class BaseNotifier implements INotificationStrategy {

    private Context context;

    public BaseNotifier(Context context) {
        this.context = context;
    }

    protected Context getContext() {
        return context;
    }

    protected AlarmManager getAlarmManager() {
        return (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
    }

    public void notifyRepeating(long notificationTime, long repeatInterval, PendingIntent pendingIntent, LocalNotification notification) {
        AlarmManager am = getAlarmManager();

        if (notification.repeatsRecurrently()) {
            notify(notificationTime, pendingIntent, notification);
            return;
        }

        am.setInexactRepeating(AlarmManager.RTC_WAKEUP, notificationTime, repeatInterval, pendingIntent);
    }
}
