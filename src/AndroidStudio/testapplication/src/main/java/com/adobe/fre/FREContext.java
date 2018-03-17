package com.adobe.fre;

import android.app.Activity;

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

    private String savedEventCode;

    public void reset() {
        savedEventCode = null;
    }

    public String getSavedEventCode() {
        return savedEventCode;
    }

    public void dispatchStatusEventAsync(final String code, String level) {
        savedEventCode = code;
    }

    public abstract void dispose();
}
