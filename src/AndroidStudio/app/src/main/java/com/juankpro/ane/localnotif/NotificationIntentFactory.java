package com.juankpro.ane.localnotif;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

/**
 * Created by jpazmino on 11/10/17.
 */

class NotificationIntentFactory implements PendingIntentFactory {
    private Context context;
    private Bundle bundle;

    NotificationIntentFactory(Context context, Bundle bundle) {
        this.context = context;
        this.bundle = bundle;
    }

    public PendingIntent createPendingIntent() {
        String code = bundle.getString(Constants.NOTIFICATION_CODE_KEY);
        assert code != null;

        return PendingIntent.getService(
                context,
                code.hashCode(),
                buildActionIntent(),
                PendingIntent.FLAG_CANCEL_CURRENT);
    }

    private Intent buildActionIntent() {
        final Intent intent = new Intent();
        String activityClassName = bundle.getString(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY);

        intent.setClassName(context, Constants.NOTIFICATION_INTENT_SERVICE);
        intent.putExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY, activityClassName);
        Logger.log("AlarmIntentService::onReceive Activity Class Name: " + activityClassName);

        intent.putExtra(Constants.NOTIFICATION_CODE_KEY, bundle.getString(Constants.NOTIFICATION_CODE_KEY));
        intent.putExtra(Constants.ACTION_DATA_KEY, bundle.getByteArray(Constants.ACTION_DATA_KEY));
        return intent;
    }
}
