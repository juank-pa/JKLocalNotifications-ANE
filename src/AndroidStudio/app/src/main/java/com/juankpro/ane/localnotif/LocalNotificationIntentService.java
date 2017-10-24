package com.juankpro.ane.localnotif;

import android.app.IntentService;
import android.content.Context;
import android.content.Intent;

/**
 * Created by Juank on 10/21/17.
 */

public class LocalNotificationIntentService extends IntentService {
    public LocalNotificationIntentService() {
        super("com.juankpro.ane.localnotif.LocalNotificationIntentService");
    }

    @Override
    public final void onHandleIntent(Intent intent) {
        Context context = getApplicationContext();

        String code = intent.getStringExtra(Constants.NOTIFICATION_CODE_KEY);
        byte[] data = intent.getByteArrayExtra(Constants.ACTION_DATA_KEY);
        new LocalNotificationDispatcher(code, data).dispatchInBackground();

        // If the app is not running, or it's running, but in the background, start it by bringing it to the foreground or launching it.
        // The OS will handle what happens correctly.
        if(!ApplicationStatus.getInForeground()) {
            bringActivityToForeground(context, intent);
        }

        logStatus(intent);
    }

    private void bringActivityToForeground(Context context, Intent intent) {
        Intent newIntent = new Intent();
        newIntent.setClassName(context, intent.getStringExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY));
        newIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(newIntent);
    }

    private void logStatus(Intent intent) {
        if(ApplicationStatus.getActive()) {
            Logger.log("LocalNotificationIntentService::onHandleIntent App is running in foreground");
        } else {
            Logger.log("LocalNotificationIntentService::onHandleIntent App is running in background or not running");
        }
        Logger.log("LocalNotificationIntentService::onHandleIntent Intent: " + intent.toString());
    }
}

