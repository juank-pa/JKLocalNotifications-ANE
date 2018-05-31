package com.juankpro.ane.localnotif.notifier;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;

import com.juankpro.ane.localnotif.LocalNotification;

public class LegacyNotifier extends BaseNotifier {

    public LegacyNotifier(Context context) {
        super(context);
    }

    @Override
    public void notify(long notificationTime, PendingIntent pendingIntent, LocalNotification localNotification) {
        getAlarmManager().set(AlarmManager.RTC_WAKEUP, notificationTime, pendingIntent);
    }
}
