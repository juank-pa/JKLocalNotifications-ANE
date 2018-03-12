package com.juankpro.ane.localnotif.decoder;

import com.adobe.fre.FREContext;
import com.juankpro.ane.localnotif.LocalNotificationSettings;
import com.juankpro.ane.localnotif.category.LocalNotificationCategory;

/**
 * Created by juank on 11/24/2017.
 */

public class LocalNotificationSettingsDecoder extends FREDecoder<LocalNotificationSettings> {
    public LocalNotificationSettingsDecoder(FREContext context) {
        super(context);
    }

    @Override
    protected LocalNotificationSettings decode() {
        LocalNotificationSettings localNotificationSettings = new LocalNotificationSettings();
        localNotificationSettings.categories =
                decodeArray("categories", getCategoryDecoder(), LocalNotificationCategory.class);
        return localNotificationSettings;
    }

    private LocalNotificationCategoryDecoder getCategoryDecoder() {
        return new LocalNotificationCategoryDecoder(getContext());
    }
}
