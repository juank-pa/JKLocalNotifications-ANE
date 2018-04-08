package com.adobe.fre;

import android.app.Activity;
import android.os.Handler;
import android.os.Looper;

import com.juankpro.ane.testapplication.MainActivity;
import com.juankpro.ane.testapplication.R;

import java.util.Map;

public abstract class FREContext {
    private MainActivity activity;
    public FREContext() {
    }

    public abstract Map<String, FREFunction> getFunctions();

    public Activity getActivity() {
        return activity;
    }

    public void setActivity(MainActivity activity) {
        this.activity = activity;
    }

    public int getResourceId(String resourceId) {
        if (resourceId.equals("okIcon"))
            return R.drawable.ic_stat_notify_ln_alert;
        if (resourceId.equals("cancelIcon"))
            return R.drawable.ic_stat_notify_ln_document;
        if (resourceId.equals("testIcon"))
            return R.drawable.ic_stat_notify_ln_error;
        return R.drawable.ic_stat_notify_dog_icon;
    }

    public void dispatchStatusEventAsync(final String code, final String level) {
        Handler mainHandler = new Handler(Looper.getMainLooper());
        Runnable myRunnable = new Runnable() {
            @Override
            public void run() {
                ((MainActivity)getActivity()).dispatchStatusEvent(code, level);
            }
        };
        mainHandler.post(myRunnable);
    }

    public abstract void dispose();
}
