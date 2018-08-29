package com.juankpro.ane.localnotif;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;

import com.juankpro.ane.localnotif.util.ApplicationStatus;

/**
 * Created by juancarlospazmino on 3/11/18.
 */

public class LifecycleCallbacks implements Application.ActivityLifecycleCallbacks {
    @Override
    public void onActivityCreated(Activity activity, Bundle bundle) {
        if (getBackgroundMode(activity)) {
            activity.moveTaskToBack(true);
        }
    }

    private boolean getBackgroundMode(Activity activity) {
        if (activity.getIntent() == null) return false;
        return activity.getIntent().getBooleanExtra(Constants.BACKGROUND_MODE_KEY, false);
    }

    @Override
    public void onActivityStarted(Activity activity) {
        ApplicationStatus.setInForeground(true);
    }

    @Override
    public void onActivityResumed(Activity activity) {

    }

    @Override
    public void onActivityPaused(Activity activity) {

    }

    @Override
    public void onActivityStopped(Activity activity) {
        ApplicationStatus.setInForeground(false);
    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle bundle) {

    }

    @Override
    public void onActivityDestroyed(Activity activity) {

    }

}
