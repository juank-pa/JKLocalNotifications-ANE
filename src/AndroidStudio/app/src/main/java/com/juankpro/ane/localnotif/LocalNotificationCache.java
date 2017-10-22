package com.juankpro.ane.localnotif;

/**
 * Created by Juank on 10/22/17.
 */

class LocalNotificationCache {
    private static LocalNotificationCache instance = new LocalNotificationCache();
    static LocalNotificationCache getInstance() {
        return instance;
    }

    private String notificationCode;
    private byte[] notificationData;

    private boolean updated = false;

    private LocalNotificationCache() {}

    String getNotificationCode() {
        return notificationCode;
    }

    byte[] getNotificationData() {
        return notificationData;
    }

    void setData(String notificationCode, byte[] data) {
        this.notificationCode = notificationCode;
        this.notificationData = data;
        updated = true;
    }

    boolean wasUpdated() {
        return updated;
    }

    void reset() {
        updated = false;
    }
}
