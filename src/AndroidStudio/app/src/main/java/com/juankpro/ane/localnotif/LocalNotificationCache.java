package com.juankpro.ane.localnotif;

/**
 * Created by Juank on 10/22/17.
 */

class LocalNotificationCache {
    private static LocalNotificationCache instance = new LocalNotificationCache();
    static LocalNotificationCache getInstance() {
        return instance;
    }

    static void clear() {
        instance = new LocalNotificationCache();
    }

    private String notificationCode;
    private byte[] notificationData;
    private String actionId;

    private boolean updated = false;

    private LocalNotificationCache() {}

    String getNotificationCode() {
        return notificationCode;
    }
    byte[] getNotificationData() {
        return notificationData;
    }
    String getActionId() {
        return actionId;
    }

    void setData(String notificationCode, byte[] data, String actionId) {
        this.notificationCode = notificationCode;
        this.notificationData = data;
        this.actionId = actionId;
        updated = true;
    }

    boolean wasUpdated() {
        return updated;
    }

    void reset() {
        updated = false;
    }
}
