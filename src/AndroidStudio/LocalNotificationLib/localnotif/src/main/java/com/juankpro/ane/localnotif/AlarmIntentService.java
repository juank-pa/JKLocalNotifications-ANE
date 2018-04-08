package com.juankpro.ane.localnotif;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.juankpro.ane.localnotif.util.Logger;
import com.juankpro.ane.localnotif.util.PersistenceManager;

/**
 * Created by Juank on 10/22/17.
 */

public class AlarmIntentService extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        Bundle bundle = intent.getExtras();
        assert bundle != null;
        boolean showInForeground = bundle.getBoolean(Constants.SHOW_IN_FOREGROUND);

        handleRepeatingNotification(context, bundle);

        NotificationDispatcher dispatcher = new NotificationDispatcher(context, bundle);

        if (showInForeground) {
            dispatcher.dispatch();
            return;
        }

        if (tryEventDispatch(bundle)) return;
        dispatcher.dispatch();
    }

    private void handleRepeatingNotification(Context context, Bundle bundle) {
        // TODO: We could use this time to remove unneeded persisted notifications (isExact data needed).
        if (isRepeatingNotification(bundle)) {
            PersistenceManager persistenceManager = new PersistenceManager(context);
            LocalNotification notification =
                    persistenceManager.readNotification(getNotificationCode(bundle));
            if (notification != null) new LocalNotificationManager(context).notify(notification);
        }
    }

    private String getNotificationCode(Bundle bundle) {
        return bundle.getString(Constants.NOTIFICATION_CODE_KEY);
    }

    private boolean isRepeatingNotification(Bundle bundle) {
        return getRepeatInterval(bundle) != 0;
    }

    private int getRepeatInterval(Bundle bundle) {
        return bundle.getInt(Constants.REPEAT_INTERVAL, 0);
    }

    private boolean tryEventDispatch(Bundle bundle) {
        String code = bundle.getString(Constants.NOTIFICATION_CODE_KEY);
        byte[] data = bundle.getByteArray(Constants.ACTION_DATA_KEY);
        return new LocalNotificationEventDispatcher(code, data).dispatchWhenInForeground();
    }
}
