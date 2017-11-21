package com.juankpro.ane.localnotif;

import java.util.Set;
import java.util.Date;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import com.juankpro.ane.localnotif.util.Logger;
import com.juankpro.ane.localnotif.util.PersistenceManager;

public class AlarmRestoreOnBoot extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        if(intent.getAction() == null || !intent.getAction().equals(Intent.ACTION_BOOT_COMPLETED)) {
            return;
        }

        PersistenceManager persistenceManager = new PersistenceManager(context);
        final Set<String> notificationIds = persistenceManager.readNotificationKeys();

        final LocalNotificationManager manager = new LocalNotificationManager(context);
        Date curDate = new Date();

        for (String notificationId : notificationIds) {
            try {
                LocalNotification notification = persistenceManager.readNotification(notificationId);

                if (notification.fireDate.getTime() >= curDate.getTime()) {
                    manager.notify(notification);
                } else {
                    manager.cancel(notification.code);
                }
            }
            catch (Exception e) {
                Logger.log("AlarmRestoreOnBoot: Error while restoring alarm details after reboot: " + e.toString());
            }

            Logger.log("AlarmRestoreOnBoot: Successfully restored alarms upon reboot");
        }
    }
}
