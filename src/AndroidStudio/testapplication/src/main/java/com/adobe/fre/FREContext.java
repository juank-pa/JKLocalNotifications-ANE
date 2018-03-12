package com.adobe.fre;

import android.app.Activity;

import com.juankpro.ane.localnotif.util.Logger;

import java.util.Map;

public abstract class FREContext {
    private Activity activity;

    public FREContext() {
    }

    public abstract Map<String, FREFunction> getFunctions();

    public Activity getActivity() {
        return activity;
    }

    public void setActivity(Activity activity) {
        this.activity = activity;
    }

    public int getResourceId(String resourceId) {
        return com.juankpro.ane.localnotif.R.drawable.ic_stat_notify_ln_alert;
    }

    public void dispatchStatusEventAsync(String code, String level) {
        Logger.log("dispatchStatusEventAsync("+code+","+level+")");
    }

    public abstract void dispose();
}
