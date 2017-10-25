package com.juankpro.ane.localnotif;

/**
 * Created by Juank on 10/22/17.
 */

class LocalNotificationDispatcher {
    private String code;
    private byte[] data;
    private LocalNotificationsContext notificationContext;

    LocalNotificationDispatcher(LocalNotificationsContext notificationContext, String code, byte[] data) {
        this.notificationContext = notificationContext;
        this.code = code;
        this.data = data;
    }

    LocalNotificationDispatcher(String code, byte[] data) {
        this(null, code, data);
    }

    LocalNotificationsContext getNotificationContext() {
        if (notificationContext == null) {
            return LocalNotificationsContext.getInstance();
        }
        return notificationContext;
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
            getNotificationContext().dispatchNotificationSelectedEvent();
            return true;
        }
        return false;
    }
}
