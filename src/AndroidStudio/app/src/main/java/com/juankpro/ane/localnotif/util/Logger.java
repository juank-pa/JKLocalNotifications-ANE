package com.juankpro.ane.localnotif.util;

import android.util.Log;

/**
 * Created by Juank on 10/22/17.
 */

public class Logger {
    public static void log(String message) {
        try{ Log.d("JKNotification", message); } catch(Exception ignored) {}
    }

    public static void error(String message) {
        try{ Log.e("JKNotification", message); } catch(Exception ignored) {}
    }
}
