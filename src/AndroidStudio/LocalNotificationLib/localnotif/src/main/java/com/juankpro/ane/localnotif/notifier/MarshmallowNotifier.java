package com.juankpro.ane.localnotif.notifier;

import android.annotation.TargetApi;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.os.Build;

import com.juankpro.ane.localnotif.LocalNotification;

@TargetApi(Build.VERSION_CODES.M)
public class MarshmallowNotifier extends KitKatNotifier {

    public MarshmallowNotifier(Context context) {
        super(context);
    }

    @Override
    public void notify(long notificationTime, PendingIntent pendingIntent, LocalNotification localNotification) {
        if (!localNotification.allowWhileIdle) {
            super.notify(notificationTime, pendingIntent, localNotification);
            return;
        }

        AlarmManager am = getAlarmManager();

        if (localNotification.isExact) {
            am.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, notificationTime, pendingIntent);
            return;
        }

        am.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, notificationTime, pendingIntent);
    }
}
