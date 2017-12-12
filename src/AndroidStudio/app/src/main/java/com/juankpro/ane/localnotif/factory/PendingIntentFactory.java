package com.juankpro.ane.localnotif.factory;

import android.app.PendingIntent;

/**
 * Created by jpazmino on 11/10/17.
 */

public interface PendingIntentFactory {
    PendingIntent createPendingIntent();
    PendingIntent createPendingIntent(String actionId, boolean backgroundMode);
}
