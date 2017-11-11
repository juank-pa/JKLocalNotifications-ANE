package com.juankpro.ane.localnotif;

import android.app.Notification;
import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;

/**
 * Created by Juank on 11/9/17.
 */

class NotificationFactory {
    private Context context;
    private Bundle bundle;

    NotificationFactory(Context context, Bundle bundle) {
        this.context = context;
        this.bundle = bundle;
    }

    Notification create(PendingIntentFactory intentFactory) {
        int numberAnnotation = bundle.getInt(Constants.NUMBER_ANNOTATION);
        int iconResource = bundle.getInt(Constants.ICON_RESOURCE);
        String tickerText = bundle.getString(Constants.TICKER_TEXT);
        String title = bundle.getString(Constants.TITLE);
        String body = bundle.getString(Constants.BODY);

        NotificationCompat.BigTextStyle style = new NotificationCompat.BigTextStyle()
                .bigText(body);
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context)
                .setSmallIcon(iconResource)
                .setContentTitle(title)
                .setContentText(body)
                .setTicker(tickerText)
                .setDefaults(getDefaults())
                .setNumber(numberAnnotation)
                .setStyle(style);

        setupMiscellaneous(builder);

        if (bundle.getBoolean(Constants.HAS_ACTION)) {
            builder.setContentIntent(intentFactory.createPendingIntent());
        }
        return builder.build();
    }

    private int getDefaults() {
        return soundDefault(bundle.getBoolean(Constants.PLAY_SOUND)) |
                vibrateDefault(bundle.getBoolean(Constants.VIBRATE)) |
                Notification.DEFAULT_LIGHTS;
    }

    private int soundDefault(boolean playSound) {
        return playSound? Notification.DEFAULT_SOUND : 0;
    }

    private int vibrateDefault(boolean vibrate) {
        return vibrate? Notification.DEFAULT_VIBRATE : 0;
    }

    private void setupMiscellaneous(NotificationCompat.Builder builder) {
        String alertPolicy = bundle.getString(Constants.ALERT_POLICY);
        builder.setOngoing(bundle.getBoolean(Constants.ON_GOING))
                .setAutoCancel(bundle.getBoolean(Constants.CANCEL_ON_SELECT))
                .setOnlyAlertOnce(alertPolicy != null && alertPolicy.compareTo("firstNotification") == 0);
    }
}
