package com.juankpro.ane.localnotif;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
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
        Logger.log("numberAnnotation " + numberAnnotation);
        Logger.log("iconResource " + iconResource);
        Logger.log("tickerText " + tickerText);
        Logger.log("title " + title);
        Logger.log("body " + body);
        Logger.log("getDefaults " + getDefaults());
        Logger.log("Before builder " + context);

        try {
            NotificationCompat.Builder builder =
                    new NotificationCompat.Builder(context)
                            .setSmallIcon(iconResource)
                            .setContentTitle(title)
                            .setContentText(body)
                            .setTicker(tickerText)
                            .setDefaults(getDefaults())
                            .setNumber(numberAnnotation);
            Logger.log("After builder");
            setupMiscellaneous(builder);
            setupAction(builder);
            return builder;
        }
        catch(Throwable e) {
            Logger.log("Error " + e.toString());
        }
        return null;
    }

    private int getDefaults() {
        return soundDefault(bundle.getBoolean(Constants.PLAY_SOUND)) |
                vibrateDefault(bundle.getBoolean(Constants.VIBRATE)) |
                lightDefault(true);
    }

    private int soundDefault(boolean playSound) {
        return playSound? Notification.DEFAULT_SOUND : 0;
    }

    private int vibrateDefault(boolean vibrate) {
        return vibrate? Notification.DEFAULT_VIBRATE : 0;
    }

    private int lightDefault(boolean showLights) {
        return showLights? Notification.DEFAULT_LIGHTS : 0;
    }

    private void setupAction(NotificationCompat.Builder builder) {
        if (!bundle.getBoolean(Constants.HAS_ACTION)) { return; }

        String code = bundle.getString(Constants.NOTIFICATION_CODE_KEY);
        Logger.log("setupAction code " + code);
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
        Logger.log("alertPolicy " + alertPolicy);
        Logger.log("ongoing " + bundle.getBoolean(Constants.ON_GOING));
        Logger.log("auto cancel " + bundle.getBoolean(Constants.CANCEL_ON_SELECT));
        builder.setOngoing(bundle.getBoolean(Constants.ON_GOING))
                .setAutoCancel(bundle.getBoolean(Constants.CANCEL_ON_SELECT))
                .setOnlyAlertOnce(alertPolicy != null && alertPolicy.compareTo("firstNotification") == 0);
    }
}
