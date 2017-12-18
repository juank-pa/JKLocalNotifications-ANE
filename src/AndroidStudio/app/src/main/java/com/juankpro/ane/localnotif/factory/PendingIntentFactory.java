package com.juankpro.ane.localnotif.factory;

import android.app.PendingIntent;

/**
 * Created by jpazmino on 11/10/17.
 */

public interface PendingIntentFactory {
    PendingIntent createPendingIntent();
    PendingIntent createActionPendingIntent(String actionId, boolean backgroundMode);
    PendingIntent createTextInputActionPendingIntent(String actionId, boolean backgroundMode);
}
