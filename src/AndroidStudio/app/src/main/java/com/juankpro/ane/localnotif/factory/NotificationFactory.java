package com.juankpro.ane.localnotif.factory;

import android.app.Notification;
import android.app.PendingIntent;
import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;

import com.juankpro.ane.localnotif.Constants;
import com.juankpro.ane.localnotif.category.LocalNotificationAction;
import com.juankpro.ane.localnotif.category.LocalNotificationCategory;
import com.juankpro.ane.localnotif.category.LocalNotificationCategoryManager;
import com.juankpro.ane.localnotif.util.Logger;

/**
 * Created by Juank on 11/9/17.
 */

public class NotificationFactory {
    private Context context;
    private Bundle bundle;

    public NotificationFactory(Context context, Bundle bundle) {
        this.context = context;
        this.bundle = bundle;
    }

    public Notification create(PendingIntentFactory intentFactory) {
        int numberAnnotation = bundle.getInt(Constants.NUMBER_ANNOTATION);
        int iconResource = bundle.getInt(Constants.ICON_RESOURCE);
        String tickerText = bundle.getString(Constants.TICKER_TEXT);
        String title = bundle.getString(Constants.TITLE);
        String body = bundle.getString(Constants.BODY);
        int priority = bundle.getInt(Constants.PRIORITY);

        NotificationCompat.BigTextStyle style = new NotificationCompat.BigTextStyle()
                .bigText(body);
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context)
                .setSmallIcon(iconResource)
                .setContentTitle(title)
                .setContentText(body)
                .setTicker(tickerText)
                .setDefaults(getDefaults())
                .setNumber(numberAnnotation)
                .setStyle(style)
                .setPriority(priority);

        buildActions(builder, intentFactory);
        setupSound(builder);
        setupMiscellaneous(builder);

        if (bundle.getBoolean(Constants.HAS_ACTION)) {
            builder.setContentIntent(intentFactory.createPendingIntent());
        }
        return builder.build();
    }

    private void buildActions(NotificationCompat.Builder builder, PendingIntentFactory intentFactory) {
        String categoryName = bundle.getString(Constants.CATEGORY);
        LocalNotificationCategoryManager categoryManager = new LocalNotificationCategoryManager(context);
        LocalNotificationCategory category = categoryManager.readCategory(categoryName);

        if (category != null) {
            Logger.log("NotificationFactory::buildActions Category id: " + category.identifier);
            for (LocalNotificationAction action : category.actions) {
                Logger.log(
                        "NotificationFactory::buildActions Action: " +
                                action.icon + ", " + action.title + ", " + action.identifier
                );
                builder.addAction(action.icon, action.title, intentFactory.createPendingIntent(action.identifier));
            }
        }
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

    private void setupMiscellaneous(NotificationCompat.Builder builder) {
        String alertPolicy = bundle.getString(Constants.ALERT_POLICY);
        builder.setOngoing(bundle.getBoolean(Constants.ON_GOING))
                .setAutoCancel(bundle.getBoolean(Constants.CANCEL_ON_SELECT))
                .setOnlyAlertOnce(alertPolicy != null && alertPolicy.compareTo("firstNotification") == 0);
    }
}
