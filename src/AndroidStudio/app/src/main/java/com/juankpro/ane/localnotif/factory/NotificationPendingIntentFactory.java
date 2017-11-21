package com.juankpro.ane.localnotif.factory;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.juankpro.ane.localnotif.Constants;
import com.juankpro.ane.localnotif.util.Logger;

/**
 * Created by jpazmino on 11/10/17.
 */

public class NotificationPendingIntentFactory implements PendingIntentFactory {
    private Context context;
    private Bundle bundle;

    public NotificationPendingIntentFactory(Context context, Bundle bundle) {
        this.context = context;
        this.bundle = bundle;
    }

    public PendingIntent createPendingIntent() {
        return createPendingIntent(null);
    }


    public PendingIntent createPendingIntent(String actionId) {
        return PendingIntent.getService(
                context,
                intentHashCode(actionId),
                buildActionIntent(actionId),
                PendingIntent.FLAG_CANCEL_CURRENT);
    }

    private Intent buildActionIntent(String actionId) {
        final Intent intent = new Intent();
        String activityClassName = bundle.getString(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY);

        intent.setClassName(context, Constants.NOTIFICATION_INTENT_SERVICE);
        intent.putExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY, activityClassName);

        intent.putExtra(Constants.NOTIFICATION_CODE_KEY, bundle.getString(Constants.NOTIFICATION_CODE_KEY));
        intent.putExtra(Constants.ACTION_DATA_KEY, bundle.getByteArray(Constants.ACTION_DATA_KEY));
        Logger.log("NotificationPendingIntentFactory::buildActionIntent Activity Class Name: " + activityClassName);

        if (actionId != null) {
            intent.putExtra(Constants.ACTION_ID_KEY, actionId);
            Logger.log("NotificationPendingIntentFactory::buildActionIntent Action id: " + actionId);
        }
        return intent;
    }

    private int intentHashCode(String actionId) {
        String code = bundle.getString(Constants.NOTIFICATION_CODE_KEY);
        assert code != null;
        if (actionId == null) return code.hashCode();
        return (code + actionId).hashCode();
    }
}
