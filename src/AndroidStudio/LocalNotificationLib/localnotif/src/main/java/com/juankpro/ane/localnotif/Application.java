package com.juankpro.ane.localnotif;

/**
 * Created by juancarlospazmino on 3/2/18.
 */

public class Application extends android.app.Application {

    @Override
    public void onCreate() {
        super.onCreate();
        registerActivityLifecycleCallbacks(new LifecycleCallbacks());
    }
}
