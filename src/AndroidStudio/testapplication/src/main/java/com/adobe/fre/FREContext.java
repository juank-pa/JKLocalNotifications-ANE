package com.adobe.fre;

import android.app.Activity;

import com.juankpro.ane.testapplication.R;

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
        return R.drawable.ic_stat_notify_dog_icon;
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
