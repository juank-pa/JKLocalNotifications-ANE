package com.juankpro.ane.localnotif.factory;

import android.app.Notification;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;

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
    private Notification.Builder builder;
    private SoundSettings soundSettings;
    private LocalNotificationCategory category;

    public NotificationFactory(Context context, Bundle bundle) {
        this.context = context;
        this.bundle = bundle;
        soundSettings = new SoundSettings(bundle);
        category = getCategory();

        if (shouldNotTargetChannel(category)) {
            builder = new Notification.Builder(context);
        }
        else {
            builder = new Notification.Builder(context, category.identifier);
        }
    }

    private boolean shouldNotTargetChannel(LocalNotificationCategory category) {
        return category == null || category.name == null ||
                Build.VERSION.SDK_INT < Build.VERSION_CODES.O ||
                context.getApplicationInfo().targetSdkVersion < Build.VERSION_CODES.O;
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

        Notification.BigTextStyle style = new Notification.BigTextStyle()
                .bigText(body);
        builder
                .setSmallIcon(iconResource)
                .setContentTitle(title)
                .setContentText(body)
                .setTicker(tickerText)
                .setDefaults(getDefaults())
                .setNumber(numberAnnotation)
                .setStyle(style)
                .setSound(soundSettings.getSoundUri())
                .setPriority(priority);
    }

    private void buildActions(PendingIntentFactory intentFactory) {
        if (category == null) return;

        NotificationActionBuilder actionBuilder = new NotificationActionBuilder(intentFactory, builder);
        for (LocalNotificationAction action : category.actions) {
            actionBuilder.build(action);
        }

        if (category.useCustomDismissAction) {
            actionBuilder.buildDismissAction();
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
