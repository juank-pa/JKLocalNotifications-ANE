package com.juankpro.ane.localnotif.notifier;

import android.annotation.TargetApi;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.os.Build;

import com.juankpro.ane.localnotif.LocalNotification;

@TargetApi(Build.VERSION_CODES.KITKAT)
public class KitKatNotifier extends BaseNotifier {

    public KitKatNotifier(Context context) {
        super(context);
    }

    @Override
    public void notify(long notificationTime, PendingIntent pendingIntent, LocalNotification localNotification) {
        AlarmManager am = getAlarmManager();

        if (localNotification.isExact) {
            am.setExact(AlarmManager.RTC_WAKEUP, notificationTime, pendingIntent);
            return;
        }

        am.set(AlarmManager.RTC_WAKEUP, notificationTime, pendingIntent);
    }
}
