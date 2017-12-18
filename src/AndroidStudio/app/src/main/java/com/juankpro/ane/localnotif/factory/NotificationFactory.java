package com.juankpro.ane.localnotif.factory;

import android.app.Notification;
import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;

import com.juankpro.ane.localnotif.Constants;
import com.juankpro.ane.localnotif.SoundSettings;
import com.juankpro.ane.localnotif.category.LocalNotificationAction;
import com.juankpro.ane.localnotif.category.LocalNotificationCategory;
import com.juankpro.ane.localnotif.category.LocalNotificationCategoryManager;

/**
 * Created by Juank on 11/9/17.
 */

public class NotificationFactory {
    private Context context;
    private Bundle bundle;
    private NotificationCompat.Builder builder;

    public NotificationFactory(Context context, Bundle bundle) {
        this.context = context;
        this.bundle = bundle;
        builder = new NotificationCompat.Builder(context);
    }

    public Notification create(PendingIntentFactory intentFactory) {
        buildCommon();
        buildActions(intentFactory);
        buildDefaultAction(intentFactory);
        buildMiscellaneous();
        return builder.build();
    }

    private void buildCommon() {
        int numberAnnotation = bundle.getInt(Constants.NUMBER_ANNOTATION);
        int iconResource = bundle.getInt(Constants.ICON_RESOURCE);
        String tickerText = bundle.getString(Constants.TICKER_TEXT);
        String title = bundle.getString(Constants.TITLE);
        String body = bundle.getString(Constants.BODY);
        int priority = bundle.getInt(Constants.PRIORITY);

        NotificationCompat.BigTextStyle style = new NotificationCompat.BigTextStyle()
                .bigText(body);
        builder
                .setSmallIcon(iconResource)
                .setContentTitle(title)
                .setContentText(body)
                .setTicker(tickerText)
                .setDefaults(getDefaults())
                .setNumber(numberAnnotation)
                .setStyle(style)
                .setPriority(priority);
    }

    private void buildActions(PendingIntentFactory intentFactory) {
        LocalNotificationCategory category = getCategory();
        if (category != null) {
            NotificationActionFactory actionFactory = new NotificationActionFactory(intentFactory);
            for (LocalNotificationAction action : category.actions) {
                builder.addAction(actionFactory.create(action));
            }
        }
    }

    private LocalNotificationCategory getCategory() {
        String categoryName = bundle.getString(Constants.CATEGORY);
        return new LocalNotificationCategoryManager(context).readCategory(categoryName);
    }

    private void buildDefaultAction(PendingIntentFactory intentFactory) {
        if (bundle.getBoolean(Constants.HAS_ACTION)) {
            builder.setContentIntent(intentFactory.createPendingIntent());
        }
    }

    private int getDefaults() {
        SoundSettings soundSettings = new SoundSettings(bundle);
        return soundSettings.getSoundDefault() |
                getVibrateDefault() |
                Notification.DEFAULT_LIGHTS;
    }

    private int getVibrateDefault() {
        boolean vibrate = bundle.getBoolean(Constants.VIBRATE);
        return vibrate? Notification.DEFAULT_VIBRATE : 0;
    }

    private void buildMiscellaneous() {
        String alertPolicy = bundle.getString(Constants.ALERT_POLICY);
        builder.setOngoing(bundle.getBoolean(Constants.ON_GOING))
                .setAutoCancel(bundle.getBoolean(Constants.CANCEL_ON_SELECT))
                .setOnlyAlertOnce(alertPolicy != null && alertPolicy.compareTo("firstNotification") == 0);
    }
}
