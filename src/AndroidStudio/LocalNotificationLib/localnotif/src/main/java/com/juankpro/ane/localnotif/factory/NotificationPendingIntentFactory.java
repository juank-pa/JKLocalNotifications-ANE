package com.juankpro.ane.localnotif.factory;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.juankpro.ane.localnotif.Constants;
import com.juankpro.ane.localnotif.TextInputActionIntentService;

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
        return createActionPendingIntent(null, false);
    }

    public PendingIntent createDeletePendingIntent() {
        return createActionPendingIntent(Constants.NOTIFICATION_DISMISS_ACTION, true);
    }

    public PendingIntent createActionPendingIntent(String actionId, boolean backgroundMode) {
        return PendingIntent.getService(
                context,
                intentHashCode(actionId),
                buildActionIntent(actionId, backgroundMode),
                PendingIntent.FLAG_UPDATE_CURRENT);
    }

    public PendingIntent createTextInputActionPendingIntent(String actionId, boolean backgroundMode) {
        return PendingIntent.getBroadcast(
                context,
                intentHashCode(actionId),
                buildTextInputActionIntent(actionId, backgroundMode),
                PendingIntent.FLAG_UPDATE_CURRENT);
    }

    private Intent buildTextInputActionIntent(String actionId, boolean backgroundMode) {
        return buildIntent(actionId, backgroundMode)
                .setClass(context, TextInputActionIntentService.class);
    }

    private Intent buildActionIntent(String actionId, boolean backgroundMode) {
        return buildIntent(actionId, backgroundMode)
                .setClassName(context, Constants.NOTIFICATION_INTENT_SERVICE);
    }

    private Intent buildIntent(String actionId, boolean backgroundMode) {
        final Intent intent = new Intent();
        String activityClassName = bundle.getString(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY);

        intent.putExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY, activityClassName);
        intent.putExtra(Constants.NOTIFICATION_CODE_KEY, bundle.getString(Constants.NOTIFICATION_CODE_KEY));
        intent.putExtra(Constants.ACTION_DATA_KEY, bundle.getByteArray(Constants.ACTION_DATA_KEY));
        intent.putExtra(Constants.BACKGROUND_MODE_KEY, backgroundMode);
        if (actionId != null) intent.putExtra(Constants.ACTION_ID_KEY, actionId);

        return intent;
    }

    private int intentHashCode(String actionId) {
        String code = bundle.getString(Constants.NOTIFICATION_CODE_KEY);
        assert code != null;
        if (actionId == null) return code.hashCode();
        return (code + actionId).hashCode();
    }
}
