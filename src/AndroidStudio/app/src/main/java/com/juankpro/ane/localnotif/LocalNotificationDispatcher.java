package com.juankpro.ane.localnotif;

import android.content.Context;

/**
 * Created by Juank on 10/22/17.
 */

class LocalNotificationDispatcher {
    private Context context;

    LocalNotificationDispatcher(Context context) {
        this.context = context;
    }

    boolean attemptDispatch(String code, byte[] data) {
        LocalNotificationCache.getInstance().setData(code, data);

        if (ApplicationStatus.getStatus(context) == ApplicationStatus.FOREGORUND && LocalNotificationsContext.hasInstance()) {
            LocalNotificationsContext.getInstance().dispatchNotificationSelectedEvent();
            return true;
        }
        return false;
    }
}
