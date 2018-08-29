package com.juankpro.ane.localnotif.factory;

import android.content.Context;
import android.os.Build;

import com.juankpro.ane.localnotif.notifier.INotificationStrategy;
import com.juankpro.ane.localnotif.notifier.KitKatNotifier;
import com.juankpro.ane.localnotif.notifier.LegacyNotifier;
import com.juankpro.ane.localnotif.notifier.MarshmallowNotifier;

public class NotificationStrategyFactory {

    private Context context;

    public NotificationStrategyFactory(Context context) {
        this.context = context;
    }

    public INotificationStrategy create() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
            return new LegacyNotifier(context);
        }
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return new KitKatNotifier(context);
        }
        return new MarshmallowNotifier(context);
    }
}
