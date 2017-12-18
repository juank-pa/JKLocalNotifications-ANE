package com.juankpro.ane.localnotif;

import android.app.IntentService;
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
        boolean backgroundMode = intent.getBooleanExtra(Constants.BACKGROUND_MODE_KEY, false);

        sendBroadcast(new Intent(Intent.ACTION_CLOSE_SYSTEM_DIALOGS));

        tryEventDispatch(intent);

        handleResponse(intent);

        logStatus(intent);
        if(backgroundMode) {
            if (!ApplicationStatus.getActive()) openActivity(intent);
        }
        else if (!ApplicationStatus.getInForeground()) {
            openActivity(intent);
        }
    }

    private void tryEventDispatch(Intent intent) {
        String code = intent.getStringExtra(Constants.NOTIFICATION_CODE_KEY);
        byte[] data = intent.getByteArrayExtra(Constants.ACTION_DATA_KEY);
        String actionId = intent.getStringExtra(Constants.ACTION_ID_KEY);
        String userResponse = intent.getStringExtra(Constants.USER_RESPONSE_KEY);
        Logger.log("LocalNotificationIntentService trying event dispatch");
        new LocalNotificationEventDispatcher(code, data, actionId, userResponse).dispatchWhenActive();
    }

    private void handleResponse(Intent intent) {
        String userResponse = intent.getStringExtra(Constants.USER_RESPONSE_KEY);
        if (userResponse == null) return;
        new NotificationDispatcher(getApplicationContext(), intent.getExtras()).dispatch();
    }

    private void openActivity(Intent intent) {
        Intent newIntent = new Intent();
        newIntent.setClassName(getApplicationContext(), intent.getStringExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY));
        newIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        getApplicationContext().startActivity(newIntent);
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