package com.juankpro.ane.localnotif.decoder;

import com.adobe.fre.FREContext;
import com.juankpro.ane.localnotif.category.LocalNotificationAction;

/**
 * Created by juank on 11/22/2017.
 */

public class LocalNotificationActionDecoder extends FREDecoder<LocalNotificationAction> {
    public LocalNotificationActionDecoder(FREContext context) {
        super(context);
    }

    @Override
    protected LocalNotificationAction decode() {
        LocalNotificationAction localNotificationAction = new LocalNotificationAction();
        localNotificationAction.identifier = decodeString("identifier", localNotificationAction.identifier);
        localNotificationAction.title = decodeString("title", localNotificationAction.title);
        localNotificationAction.icon = decodeResourceId("icon");
        localNotificationAction.textInputPlaceholder = decodeString("textInputPlaceholder", null);
        localNotificationAction.isBackground = decodeBoolean("isBackground", false);
        return localNotificationAction;
    }
}
