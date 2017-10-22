package com.juankpro.ane.localnotif;

import android.app.ActivityManager;
import android.content.Context;

import java.util.List;

/**
 * Created by Juank on 10/22/17.
 */

class ApplicationStatus {
    static final int FOREGORUND = 1;
    static final int BACKGROUND = 2;
    static final int NOT_STARTED = 3;

    static int getStatus(Context context) {
        return new ApplicationStatus(context).getStatus();
    }

    private Context context;

    private ApplicationStatus(Context context) {
        this.context = context;
    }

    int getStatus() {
        ActivityManager activityManager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningAppProcessInfo> appProcesses = activityManager.getRunningAppProcesses();
        if (appProcesses != null) {
            final String packageName = context.getPackageName();
            for (ActivityManager.RunningAppProcessInfo appProcess : appProcesses) {
                if (appProcess.processName.equals(packageName)) {
                    if (appProcess.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND) {
                        return FOREGORUND;
                    }
                    return BACKGROUND;
                }
            }
        }

        return NOT_STARTED;
    }
}
