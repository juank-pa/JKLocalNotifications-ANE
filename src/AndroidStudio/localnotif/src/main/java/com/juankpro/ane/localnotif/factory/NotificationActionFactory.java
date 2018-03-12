package com.juankpro.ane.localnotif.factory;

import android.app.PendingIntent;
import android.support.v4.app.NotificationCompat;
import android.support.v4.app.RemoteInput;

import com.juankpro.ane.localnotif.Constants;
import com.juankpro.ane.localnotif.category.LocalNotificationAction;

/**
 * Created by juank on 12/17/2017.
 */

public class NotificationActionFactory {
    private PendingIntentFactory intentFactory;

    public NotificationActionFactory(PendingIntentFactory intentFactory) {
        this.intentFactory = intentFactory;
    }

    public NotificationCompat.Action create(LocalNotificationAction action) {
        NotificationCompat.Action.Builder builder =
                new NotificationCompat.Action.Builder(action.icon, action.title,
                        createActionPendingIntent(action)
                );
        addRemoteInput(builder, action);
        return builder.build();
    }

    private void addRemoteInput(NotificationCompat.Action.Builder builder, LocalNotificationAction action) {
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
}
