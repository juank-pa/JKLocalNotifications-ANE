package com.juankpro.ane.localnotif;

/**
 * Created by Juank on 10/22/17.
 */

class LocalNotificationEventDispatcher {
    private String code;
    private byte[] data;

    LocalNotificationEventDispatcher(String code, byte[] data) {
        this.code = code;
        this.data = data;
    }

    boolean dispatchWhenInForeground() {
        return dispatchWhen(ApplicationStatus.getInForeground());
    }

    boolean dispatchWhenActive() {
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
