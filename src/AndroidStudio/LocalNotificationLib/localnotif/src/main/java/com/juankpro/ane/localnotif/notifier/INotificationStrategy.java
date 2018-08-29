package com.juankpro.ane.localnotif.notifier;

import android.app.PendingIntent;

import com.juankpro.ane.localnotif.LocalNotification;

public interface INotificationStrategy {
    void notify(long notificationTime, PendingIntent pendingIntent, LocalNotification localNotification);
    void notifyRepeating(long notificationTime, long repeatInterval, PendingIntent pendingIntent, LocalNotification notification);
}
