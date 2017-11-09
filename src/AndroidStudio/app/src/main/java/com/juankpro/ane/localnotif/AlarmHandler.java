package com.juankpro.ane.localnotif;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;

/**
 * Created by Juank on 10/21/17.
 */

class AlarmHandler {
    private Context context;
    private Bundle bundle;

    AlarmHandler(Context context, Bundle bundle) {
        this.context = context;
        this.bundle = bundle;
    }

    void postNotification() {
        String code = bundle.getString(Constants.NOTIFICATION_CODE_KEY);
        final NotificationManager notificationManager = (NotificationManager)context.getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.notify(code, Constants.STANDARD_NOTIFICATION_ID, getBuilder().build());
    }

    private NotificationCompat.Builder getBuilder() {
        int numberAnnotation = bundle.getInt(Constants.NUMBER_ANNOTATION);
        int iconResource = bundle.getInt(Constants.ICON_RESOURCE);
        String tickerText = bundle.getString(Constants.TICKER_TEXT);
        String title = bundle.getString(Constants.TITLE);
        String body = bundle.getString(Constants.BODY);

        NotificationCompat.Builder builder =
                new NotificationCompat.Builder(context)
                        .setSmallIcon(iconResource)
                        .setContentTitle(title)
                        .setContentText(body)
                        .setTicker(tickerText)
                        .setDefaults(getDefaults())
                        .setNumber(numberAnnotation);
        setupSound(builder);
        setupMiscellaneous(builder);
        setupAction(builder);
        return builder;
    }

    private int getDefaults() {
        return getSoundDefault() |
                getVibrateDefault() |
                Notification.DEFAULT_LIGHTS;
    }

    private int getSoundDefault() {
        return shouldPlayDefaultSound()? Notification.DEFAULT_SOUND : 0;
    }

    private int getVibrateDefault() {
        boolean vibrate = bundle.getBoolean(Constants.VIBRATE);
        return vibrate? Notification.DEFAULT_VIBRATE : 0;
    }

    private boolean shouldPlayDefaultSound() {
        return shouldPlaySound() && getSoundName() == null;
    }

    private boolean shouldPlayCustomSound() {
        return shouldPlaySound() && getSoundName() != null;
    }

    private boolean shouldPlaySound() {
        return bundle.getBoolean(Constants.PLAY_SOUND);
    }

    private String getSoundName() {
        return bundle.getString(Constants.SOUND_NAME);
    }

    private void setupSound(NotificationCompat.Builder builder) {
        if (shouldPlayCustomSound()) {
            builder.setSound(Uri.parse("content://com.juankpro.ane.localnotif.provider/" + getSoundName()));
        }
    }

    private void setupAction(NotificationCompat.Builder builder) {
        if (!bundle.getBoolean(Constants.HAS_ACTION)) { return; }

        String code = bundle.getString(Constants.NOTIFICATION_CODE_KEY);
        assert code != null;

        final PendingIntent pendingIntent =
                PendingIntent.getService(
                        context,
                        code.hashCode(),
                        buildActionIntent(),
                        PendingIntent.FLAG_CANCEL_CURRENT);
        builder.setContentIntent(pendingIntent);
    }

    private Intent buildActionIntent() {
        final Intent intent = new Intent();
        String activityClassName = bundle.getString(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY);

        intent.setClassName(context, "com.juankpro.ane.localnotif.LocalNotificationIntentService");
        intent.putExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY, activityClassName);
        Logger.log("AlarmIntentService::onReceive Activity Class Name: " + activityClassName);

        intent.putExtra(Constants.NOTIFICATION_CODE_KEY, bundle.getString(Constants.NOTIFICATION_CODE_KEY));
        intent.putExtra(Constants.ACTION_DATA_KEY, bundle.getByteArray(Constants.ACTION_DATA_KEY));
        return intent;
    }

    private void setupMiscellaneous(NotificationCompat.Builder builder) {
        String alertPolicy = bundle.getString(Constants.ALERT_POLICY);
        builder.setOngoing(bundle.getBoolean(Constants.ON_GOING))
                .setAutoCancel(bundle.getBoolean(Constants.CANCEL_ON_SELECT))
                .setOnlyAlertOnce(alertPolicy != null && alertPolicy.compareTo("firstNotification") == 0);
    }
}
