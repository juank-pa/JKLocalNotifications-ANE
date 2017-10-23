package com.juankpro.ane.localnotif;

import android.content.Context;

/**
 * Created by Juank on 10/22/17.
 */

class LocalNotificationDispatcher {
    private Context context;
    private String code;
    private byte[] data;

    LocalNotificationDispatcher(Context context, String code, byte[] data) {
        this.context = context;
        this.code = code;
        this.data = data;
    }

    boolean dispatchInForeground() {
        return dispatchWhen(ApplicationStatus.getInForeground());
    }

    boolean dispatchInBackground() {
        return dispatchWhen(ApplicationStatus.getActive());
    }

    private boolean dispatchWhen(boolean condition) {
        LocalNotificationCache.getInstance().setData(code, data);

        if (condition) {
            LocalNotificationsContext.getInstance().dispatchNotificationSelectedEvent();
            return true;
        }
        return false;
    }
}
