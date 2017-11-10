package com.juankpro.ane.localnotif;

import android.util.Log;

/**
 * Created by Juank on 10/22/17.
 */

class Logger {
    static void log(String message) {
        try{ Log.d("JKNotification", message); } catch(Exception ignored) {}
    }

    static void error(String message) {
        try{ Log.e("JKNotification", message); } catch(Exception ignored) {}
    }
}
