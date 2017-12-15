package com.juankpro.ane.localnotif;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.juankpro.ane.localnotif.util.Logger;

/**
 * Created by Juank on 10/22/17.
 */

public class AlarmIntentService extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        Bundle bundle = intent.getExtras();
        assert bundle != null;
        boolean showInForeground = bundle.getBoolean(Constants.SHOW_IN_FOREGROUND);

        NotificationDispatcher dispatcher = new NotificationDispatcher(context, bundle);

        if (showInForeground) {
            dispatcher.dispatch();
            return;
        }

        if (tryEventDispatch(bundle)) return;
        dispatcher.dispatch();
        Logger.log("AlarmIntentService::onReceive Intent: " + intent.toString());
    }

    private boolean tryEventDispatch(Bundle bundle) {
        String code = bundle.getString(Constants.NOTIFICATION_CODE_KEY);
        byte[] data = bundle.getByteArray(Constants.ACTION_DATA_KEY);
        return new LocalNotificationEventDispatcher(code, data, null).dispatchWhenInForeground();
    }
}

