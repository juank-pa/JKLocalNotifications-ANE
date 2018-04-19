package com.juankpro.ane.localnotif.decoder;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.juankpro.ane.localnotif.LocalNotification;
import com.juankpro.ane.localnotif.util.Logger;

/**
 * Created by juank on 11/20/2017.
 */

public class LocalNotificationDecoder extends FREDecoder<LocalNotification> {
    private String code = "";

    public LocalNotificationDecoder(FREContext context, FREObject codeObject) {
        super(context);
        try {
            code = codeObject.getAsString();
        } catch(Exception e) { e.printStackTrace(); }
    }

    @Override
    protected LocalNotification decode() {
        // Get the activity class name and pass it to the notification.
        String activityClassName = getContext().getActivity().getClass().getName();
        Logger.log("LocalNotificationsContext::decodeLocalNotification Activity Class Name: " + activityClassName);

        LocalNotification localNotification = new LocalNotification(activityClassName);

        // Notification Name.
        localNotification.code = code;

        // IMPORTANT: These property names must match the names in the Notification ActionScript class exactly.
        localNotification.fireDate = decodeDate("fireDate", localNotification.fireDate);
        localNotification.repeatInterval = decodeInt("repeatInterval", localNotification.repeatInterval);
        localNotification.isExact = decodeBoolean("isExact", localNotification.isExact);

        // Text.
        localNotification.tickerText = decodeString("tickerText", localNotification.tickerText);
        localNotification.title = decodeString("title", localNotification.title);
        localNotification.body = decodeString("body", localNotification.body);
        localNotification.category = decodeString("category", localNotification.category);

        // Sound.
        localNotification.playSound = decodeBoolean("playSound", localNotification.playSound);
        localNotification.soundName = decodeString("soundName", localNotification.soundName);

        // Vibration.
        localNotification.vibrate = decodeBoolean("vibrate", localNotification.vibrate);

        // Icon.
        localNotification.iconResourceId = decodeResourceId("iconType");
        localNotification.numberAnnotation = decodeInt("numberAnnotation", localNotification.numberAnnotation);

        // Action.
        localNotification.hasAction = decodeBoolean("hasAction", localNotification.hasAction);

        localNotification.showInForeground = decodeBoolean("showInForeground", localNotification.showInForeground);

        // Miscellaneous.
        localNotification.cancelOnSelect = decodeBoolean("cancelOnSelect", localNotification.cancelOnSelect);
        localNotification.alertPolicy = decodeString("alertPolicy", localNotification.alertPolicy);
        localNotification.ongoing = decodeBoolean("ongoing", localNotification.ongoing);
        localNotification.priority = decodeInt("priority", localNotification.priority);

        localNotification.actionData = decodeBytes("actionData", localNotification.actionData);

        return localNotification;
    }
}
