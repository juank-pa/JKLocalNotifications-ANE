package com.juankpro.ane.localnotif.util;

/**
 * Created by Juank on 10/22/17.
 */

public class ApplicationStatus {
    static private ApplicationStatus instance = new ApplicationStatus();

    public static void reset() {
        instance = new ApplicationStatus();
    }

    public static void setInForeground(boolean inForeground) {
        if (inForeground) {
            instance.moveToForeground();
            return;
        }
        instance.moveToBackground();
    }

    private boolean active = false;
    private boolean inForeground = false;

    public static boolean getActive() {
        return instance.active;
    }

    public static boolean getInForeground() {
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

/*
    NOTE: Backup plan
    private boolean getActive() {
        ActivityManager.RunningAppProcessInfo myProcess = new ActivityManager.RunningAppProcessInfo();
        ActivityManager.getMyMemoryState(myProcess);
        return (myProcess.importance != ActivityManager.RunningAppProcessInfo.IMPORTANCE_GONE);
    }
}*/
