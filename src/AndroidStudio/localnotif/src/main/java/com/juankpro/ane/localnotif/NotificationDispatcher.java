package com.juankpro.ane.localnotif;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.juankpro.ane.localnotif.factory.NotificationFactory;
import com.juankpro.ane.localnotif.factory.NotificationPendingIntentFactory;
import com.juankpro.ane.localnotif.util.PlayAudio;

/**
 * Created by juancarlospazmino on 12/14/17.
 */

class NotificationDispatcher {
    private Context context;
    private Bundle bundle;
    private String code;
    private SoundSettings soundSettings;

    NotificationDispatcher(Context context, Bundle bundle) {
        this.context = context;
        this.bundle = bundle;
        code = bundle.getString(Constants.NOTIFICATION_CODE_KEY);
        soundSettings = new SoundSettings(bundle);
    }

    void dispatch() {
        dispatchNotification();
        if (shouldPlaySound()) playSound();
    }

    private void dispatchNotification() {
        NotificationManager notificationManager = (NotificationManager)context
                .getSystemService(Context.NOTIFICATION_SERVICE);
        assert notificationManager != null;

        notificationManager.notify(
                code,
                Constants.STANDARD_NOTIFICATION_ID,
                getNotification());
    }

    private Notification getNotification() {
        NotificationFactory notificationFactory = new NotificationFactory(context, bundle);
        NotificationPendingIntentFactory intentFactory =
                new NotificationPendingIntentFactory(context, bundle);
        return notificationFactory.create(intentFactory);
    }

    private boolean shouldPlaySound() {
        return soundSettings.shouldPlayCustomSound();
    }

    private void playSound() {
        context.startService(getSoundIntent(soundSettings.getSoundName()));
    }

    private Intent getSoundIntent(String soundName) {
        Intent intent = new Intent(context, PlayAudio.class);
        intent.putExtra(Constants.SOUND_NAME, soundName);
        return intent;
    }
}
