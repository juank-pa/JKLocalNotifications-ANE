package com.juankpro.ane.localnotif;

import android.app.IntentService;
import android.content.Context;
import android.content.Intent;

/**
 * Created by Juank on 10/21/17.
 */

public class LocalNotificationIntentService extends IntentService {
    public LocalNotificationIntentService() {
        super(Constants.NOTIFICATION_INTENT_SERVICE);
    }

    @Override
    public final void onHandleIntent(Intent intent) {
        Context context = getApplicationContext();

        tryEventDispatch(intent);

        if(!ApplicationStatus.getInForeground()) bringActivityToForeground(context, intent);

        logStatus(intent);
    }

    private boolean tryEventDispatch(Intent intent) {
        String code = intent.getStringExtra(Constants.NOTIFICATION_CODE_KEY);
        byte[] data = intent.getByteArrayExtra(Constants.ACTION_DATA_KEY);
        return new LocalNotificationEventDispatcher(code, data).dispatchWhenActive();
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

