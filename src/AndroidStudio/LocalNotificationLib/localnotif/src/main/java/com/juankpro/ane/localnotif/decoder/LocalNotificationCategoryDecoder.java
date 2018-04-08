package com.juankpro.ane.localnotif.decoder;

import com.adobe.fre.FREContext;
import com.juankpro.ane.localnotif.category.LocalNotificationAction;
import com.juankpro.ane.localnotif.category.LocalNotificationCategory;

/**
 * Created by juank on 11/22/2017.
 */

public class LocalNotificationCategoryDecoder extends FREDecoder<LocalNotificationCategory> {
    public LocalNotificationCategoryDecoder(FREContext context) {
        super(context);
    }

    @Override
    protected LocalNotificationCategory decode() {
        LocalNotificationCategory localNotificationCategory = new LocalNotificationCategory();
        localNotificationCategory.identifier = decodeString("identifier", localNotificationCategory.identifier);
        localNotificationCategory.useCustomDismissAction = decodeBoolean("useCustomDismissAction", localNotificationCategory.useCustomDismissAction);
        localNotificationCategory.actions = decodeArray("actions", getActionDecoder(), LocalNotificationAction.class);

        localNotificationCategory.name = decodeString("name", localNotificationCategory.name);
        localNotificationCategory.description = decodeString("description", localNotificationCategory.description);
        localNotificationCategory.soundName = decodeString("soundName", localNotificationCategory.soundName);
        localNotificationCategory.shouldVibrate = decodeBoolean("shouldVibrate", localNotificationCategory.shouldVibrate);
        localNotificationCategory.importance = decodeInt("importance", localNotificationCategory.importance);
        return localNotificationCategory;
    }

    private LocalNotificationActionDecoder getActionDecoder() {
        return new LocalNotificationActionDecoder(getContext());
    }
}
