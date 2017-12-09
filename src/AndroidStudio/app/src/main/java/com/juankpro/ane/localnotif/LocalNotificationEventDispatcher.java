package com.juankpro.ane.localnotif;

import com.juankpro.ane.localnotif.util.ApplicationStatus;

/**
 * Created by Juank on 10/22/17.
 */

class LocalNotificationEventDispatcher {
    private String code;
    private byte[] data;
    private String actionId;

    LocalNotificationEventDispatcher(String code, byte[] data, String actionId) {
        this.code = code;
        this.data = data;
        this.actionId = actionId;
    }

    boolean dispatchWhenInForeground() {
        return dispatchWhen(ApplicationStatus.getInForeground());
    }

    boolean dispatchWhenActive() {
        return dispatchWhen(ApplicationStatus.getActive());
    }

    private boolean dispatchWhen(boolean condition) {
        LocalNotificationCache.getInstance().setData(code, data, actionId);

        if (condition) {
            LocalNotificationsContext.getInstance().dispatchNotificationSelectedEvent();
            return true;
        }
        return false;
    }
}
