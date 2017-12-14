package com.juankpro.ane.localnotif;

import android.app.IntentService;
import android.content.Context;
import android.content.Intent;

import com.juankpro.ane.localnotif.util.ApplicationStatus;
import com.juankpro.ane.localnotif.util.Logger;

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
        boolean backgroundMode = intent.getBooleanExtra(Constants.BACKGROUND_MODE_ID_KEY, false);

        sendBroadcast(new Intent(Intent.ACTION_CLOSE_SYSTEM_DIALOGS));

        tryEventDispatch(intent);

        logStatus(intent);
        if(backgroundMode) {
            if (!ApplicationStatus.getActive()) openActivityInBackground(context, intent);
        }
        else if (!ApplicationStatus.getInForeground()) {
            openActivityInForeground(context, intent);
        }
    }

    private void tryEventDispatch(Intent intent) {
        String code = intent.getStringExtra(Constants.NOTIFICATION_CODE_KEY);
        byte[] data = intent.getByteArrayExtra(Constants.ACTION_DATA_KEY);
        String actionId = intent.getStringExtra(Constants.ACTION_ID_KEY);
        Logger.log("LocalNotificationIntentService::tryEventDispatch actionId: " + actionId);
        new LocalNotificationEventDispatcher(code, data, actionId).dispatchWhenActive();
    }

    private void openActivity(Context context, Intent intent, boolean backgroundMode) {
        Intent newIntent = new Intent();
        newIntent.setClassName(context, intent.getStringExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY));
        newIntent.putExtra(Constants.BACKGROUND_MODE_ID_KEY, backgroundMode);
        newIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(newIntent);
    }

    private void openActivityInBackground(Context context, Intent intent) {
        openActivity(context, intent, true);
    }

    private void openActivityInForeground(Context context, Intent intent) {
        openActivity(context, intent, false);
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