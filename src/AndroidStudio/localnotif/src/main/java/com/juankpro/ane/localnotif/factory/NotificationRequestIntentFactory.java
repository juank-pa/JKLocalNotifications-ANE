package com.juankpro.ane.localnotif.factory;

import android.content.Context;
import android.content.Intent;

import com.juankpro.ane.localnotif.AlarmIntentService;
import com.juankpro.ane.localnotif.Constants;
import com.juankpro.ane.localnotif.LocalNotification;

/**
 * Created by juank on 12/17/2017.
 */

public class NotificationRequestIntentFactory {
    private Context context;

    public NotificationRequestIntentFactory(Context context) {
        this.context = context;
    }

    public Intent createIntent(LocalNotification localNotification) {
        final Intent intent = new Intent(context, AlarmIntentService.class);

        intent.setAction(localNotification.code);
        intent.putExtra(Constants.TITLE, localNotification.title);
        intent.putExtra(Constants.BODY, localNotification.body);
        intent.putExtra(Constants.TICKER_TEXT, localNotification.tickerText);
        intent.putExtra(Constants.NOTIFICATION_CODE_KEY, localNotification.code);
        intent.putExtra(Constants.ICON_RESOURCE, localNotification.iconResourceId);
        intent.putExtra(Constants.NUMBER_ANNOTATION, localNotification.numberAnnotation);
        intent.putExtra(Constants.PLAY_SOUND, localNotification.playSound);
        intent.putExtra(Constants.SOUND_NAME, localNotification.soundName);
        intent.putExtra(Constants.VIBRATE, localNotification.vibrate);
        intent.putExtra(Constants.CANCEL_ON_SELECT, localNotification.cancelOnSelect);
        intent.putExtra(Constants.ON_GOING, localNotification.ongoing);
        intent.putExtra(Constants.ALERT_POLICY, localNotification.alertPolicy);
        intent.putExtra(Constants.HAS_ACTION, localNotification.hasAction);
        intent.putExtra(Constants.ACTION_DATA_KEY, localNotification.actionData);
        intent.putExtra(Constants.PRIORITY, localNotification.priority);
        intent.putExtra(Constants.SHOW_IN_FOREGROUND, localNotification.showInForeground);
        intent.putExtra(Constants.CATEGORY, localNotification.category);

        if (localNotification.hasAction) {
            intent.putExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY, localNotification.activityClassName);
        }

        return intent;
    }

}
