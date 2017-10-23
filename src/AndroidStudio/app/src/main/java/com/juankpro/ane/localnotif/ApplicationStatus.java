package com.juankpro.ane.localnotif;

/**
 * Created by Juank on 10/22/17.
 */

class ApplicationStatus {
    static private ApplicationStatus instance = new ApplicationStatus();

    static void setInForeground(boolean inForeground) {
        if (inForeground) {
            instance.moveToForeground();
            return;
        }
        instance.moveToBackground();
    }

    private boolean active = false;
    private boolean inForeground = false;

    static boolean getActive() {
        return instance.active;
    }

    static boolean getInForeground() {
        return instance.inForeground;
    }

    private ApplicationStatus() {}

    private void moveToForeground() {
        active = true;
        inForeground = true;
    }

    private void moveToBackground() {
        inForeground = false;
    }
}
