package com.juankpro.ane.localnotif;

import android.util.Log;

/**
 * Created by Juank on 10/22/17.
 */

class Logger {
    static void log(String message) {
        Log.i("JKNotification", message);
    }

    static void error(String message) {
        Log.e("JKNotification", message);
    }
}
