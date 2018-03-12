package com.juankpro.ane.localnotif;

import com.juankpro.ane.localnotif.util.ApplicationStatus;
import com.juankpro.ane.localnotif.util.Logger;

/**
 * Created by Juank on 10/22/17.
 */

class LocalNotificationEventDispatcher {
    private String code;
    private byte[] data;
    private String actionId;
    private String userResponse;

    LocalNotificationEventDispatcher(String code, byte[] data) {
        this(code, data, null, null);
    }

    LocalNotificationEventDispatcher(String code, byte[] data, String actionId, String userResponse) {
        this.code = code;
        this.data = data;
        this.actionId = actionId;
        this.userResponse = userResponse;
    }

    boolean dispatchWhenInForeground() {
        return dispatchWhen(ApplicationStatus.getInForeground());
    }

    @SuppressWarnings("UnusedReturnValue")
    boolean dispatchWhenActive() {
        return dispatchWhen(ApplicationStatus.getActive());
    }

    private boolean dispatchWhen(boolean condition) {
        LocalNotificationCache.getInstance().setData(code, data, actionId, userResponse);

        if (condition) {
            Logger.log("LocalNotificationEventDispatcher dispatching event");
            LocalNotificationsContext.getInstance().dispatchNotificationSelectedEvent();
            return true;
        }
        return false;
    }
}
