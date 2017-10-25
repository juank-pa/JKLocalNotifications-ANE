package com.juankpro.ane.localnotif;

import java.util.Map;
import java.util.Set;
import java.util.Date;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;

public class AlarmRestoreOnBoot extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        final String pluginName = "JK_ANE_LocalNotification";

        // Obtain alarm details form Shared Preferences
        final SharedPreferences alarmSettings = context.getSharedPreferences(pluginName, Context.MODE_PRIVATE);
        final Map<String, ?> allAlarms = alarmSettings.getAll();
        final Set<String> alarmIds = allAlarms.keySet();

        final LocalNotificationManager manager = new LocalNotificationManager(context);
        Date curDate = new Date();

		/*
		 * For each alarm, parse its alarm options and register it again with
		 * the Alarm Manager
		 */
        for (String alarmId : alarmIds) {
            try {
                final LocalNotification notification = new LocalNotification(context.getClass().getName());

                Logger.log("Class name:" + context.getClass().getName());

                notification.deserialize(alarmSettings, alarmId);

                if (notification.fireDate.getTime() >= curDate.getTime()) {
                    manager.notify(notification);
                } else {
                    manager.cancel(notification.code);
                }
            } catch (Exception e) {
                Logger.log("AlarmRestoreOnBoot: Error while restoring alarm details after reboot: " + e.toString());
            }

            Logger.log("AlarmRestoreOnBoot: Successfully restored alarms upon reboot");
        }
    }
}
