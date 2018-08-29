package com.juankpro.ane.localnotif.factory;

import android.app.Notification;
import android.app.PendingIntent;
import android.app.RemoteInput;
import android.os.Build;

import com.juankpro.ane.localnotif.Constants;
import com.juankpro.ane.localnotif.category.LocalNotificationAction;

/**
 * Created by juank on 12/17/2017.
 */

public class NotificationActionBuilder {
    private PendingIntentFactory intentFactory;
    Notification.Builder notificationBuilder;

    public NotificationActionBuilder(PendingIntentFactory intentFactory, Notification.Builder notificationBuilder) {
        this.intentFactory = intentFactory;
        this.notificationBuilder = notificationBuilder;
    }

    public void build(LocalNotificationAction action) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT_WATCH) {
            notificationBuilder.addAction(action.icon, action.title, createActionPendingIntent(action));
            return;
        }

        Notification.Action.Builder actionBuilder = new Notification.Action.Builder(action.icon, action.title,
                createActionPendingIntent(action));
        addRemoteInput(actionBuilder, action);
        notificationBuilder.addAction(actionBuilder.build());
    }

    private void addRemoteInput(Notification.Action.Builder builder, LocalNotificationAction action) {
        if (!action.isTextInput()) return;
        RemoteInput remoteInput = new RemoteInput.Builder(Constants.USER_RESPONSE_KEY)
                .setLabel(action.textInputPlaceholder).build();
        builder.addRemoteInput(remoteInput);
    }

    private PendingIntent createActionPendingIntent(LocalNotificationAction action) {
        if (action.isTextInput()) {
            return intentFactory.createTextInputActionPendingIntent(action.identifier, action.isBackground);
        }
        return intentFactory.createActionPendingIntent(action.identifier, action.isBackground);
    }

    public void buildDismissAction() {
        notificationBuilder.setDeleteIntent(intentFactory.createDeletePendingIntent());
    }
}
