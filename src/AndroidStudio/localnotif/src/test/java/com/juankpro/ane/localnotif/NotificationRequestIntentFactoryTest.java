package com.juankpro.ane.localnotif;

import android.content.Context;
import android.content.Intent;

import com.juankpro.ane.localnotif.factory.NotificationRequestIntentFactory;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.powermock.api.mockito.PowerMockito.spy;
import static org.powermock.api.mockito.PowerMockito.when;

/**
 * Created by juank on 12/18/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({NotificationRequestIntentFactory.class})
public class NotificationRequestIntentFactoryTest {
    @Mock
    private Context context;
    @Mock
    private Intent intent;
    private LocalNotification notification = new LocalNotification("ClassName");

    private NotificationRequestIntentFactory subject;
    private NotificationRequestIntentFactory getSubject() {
        if (subject == null) { subject = new NotificationRequestIntentFactory(context); }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        try {
            PowerMockito.whenNew(Intent.class)
                    .withArguments(context, AlarmIntentService.class)
                    .thenReturn(intent);
        } catch (Throwable e) { e.printStackTrace(); }
    }

    private LocalNotification getNotification() {
        notification.hasAction = false;
        notification.code = "MyCode";
        notification.title = "Title";
        notification.body = "Body";
        notification.tickerText = "Ticker";
        notification.iconResourceId = 12;
        notification.numberAnnotation = 3;
        notification.soundName = "sound.mp3";
        notification.alertPolicy = "policy";
        notification.actionData = new byte[]{};
        notification.priority = 2;
        notification.category = "Category";
        return notification;
    }

    @Test
    public void factory_createIntent_setsUpIntent() {
        getSubject().createIntent(getNotification());

        verify(intent).setAction("MyCode");
        verify(intent).putExtra(Constants.TITLE, "Title");
        verify(intent).putExtra(Constants.BODY, "Body");
        verify(intent).putExtra(Constants.TICKER_TEXT, "Ticker");
        verify(intent).putExtra(Constants.NOTIFICATION_CODE_KEY, "MyCode");
        verify(intent).putExtra(Constants.ICON_RESOURCE, 12);
        verify(intent).putExtra(Constants.NUMBER_ANNOTATION, 3);
        verify(intent).putExtra(Constants.SOUND_NAME, "sound.mp3");
        verify(intent).putExtra(Constants.ALERT_POLICY, "policy");
        verify(intent).putExtra(Constants.ACTION_DATA_KEY, new byte[]{});
        verify(intent).putExtra(Constants.PRIORITY, 2);
        verify(intent).putExtra(Constants.CATEGORY, "Category");
    }

    @Test
    public void factory_createIntent_setsUpPlaySound() {
        LocalNotification notification = getNotification();
        notification.playSound = true;
        getSubject().createIntent(notification);
        verify(intent).putExtra(Constants.PLAY_SOUND, true);
    }

    @Test
    public void factory_createIntent_setsUpVibrate() {
        LocalNotification notification = getNotification();
        notification.vibrate = true;
        getSubject().createIntent(notification);
        verify(intent).putExtra(Constants.VIBRATE, true);
    }

    @Test
    public void factory_createIntent_setsUpCancelOngoing() {
        LocalNotification notification = getNotification();
        notification.ongoing = true;
        getSubject().createIntent(notification);
        verify(intent).putExtra(Constants.ON_GOING, true);
    }

    @Test
    public void factory_createIntent_setsUpCancelOnSelect() {
        LocalNotification notification = getNotification();
        notification.cancelOnSelect = true;
        getSubject().createIntent(notification);
        verify(intent).putExtra(Constants.CANCEL_ON_SELECT, true);
    }

    @Test
    public void factory_createIntent_setsUpShowInForeground() {
        LocalNotification notification = getNotification();
        notification.showInForeground = true;
        getSubject().createIntent(notification);
        verify(intent).putExtra(Constants.SHOW_IN_FOREGROUND, true);
    }

    @Test
    public void factory_createIntent_setsActivityClassIfItHasAction() {
        LocalNotification notification = getNotification();
        notification.hasAction = true;
        getSubject().createIntent(notification);
        verify(intent).putExtra(Constants.HAS_ACTION, true);
        verify(intent).putExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY, "ClassName");
    }

    @Test
    public void factory_createIntent_doesNotSetActivityClassIfHasNoAction() {
        LocalNotification notification = getNotification();
        notification.hasAction = false;
        getSubject().createIntent(notification);
        verify(intent).putExtra(Constants.HAS_ACTION, false);
        verify(intent, never()).putExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY, "ClassName");
    }

    @Test
    public void factory_createIntent_addsRepeatInterval_whenNotificationRepeatsRecurrently() {
        LocalNotification notification = spy(getNotification());
        when(notification.repeatsRecurrently()).thenReturn(true);
        notification.repeatInterval = LocalNotificationTimeInterval.MINUTE_CALENDAR_UNIT;
        getSubject().createIntent(notification);
        verify(intent).putExtra(Constants.REPEAT_INTERVAL, LocalNotificationTimeInterval.MINUTE_CALENDAR_UNIT);
    }

    @Test
    public void factory_createIntent_doesNotAddRepeatInterval_whenNotificationDoesNotRepeatRecurrently() {
        LocalNotification notification = spy(getNotification());
        when(notification.repeatsRecurrently()).thenReturn(false);
        notification.repeatInterval = LocalNotificationTimeInterval.MINUTE_CALENDAR_UNIT;
        getSubject().createIntent(notification);
        verify(intent, never()).putExtra(eq(Constants.REPEAT_INTERVAL), anyInt());
    }

    @Test
    public void factory_createIntent_doesNotAddRepeatIntervalWhenNonExactOrIntervalNotDefined() {
        LocalNotification notification = getNotification();

        notification.isExact = false;
        notification.repeatInterval = LocalNotificationTimeInterval.MINUTE_CALENDAR_UNIT;
        getSubject().createIntent(notification);

        notification.isExact = true;
        notification.repeatInterval = 0;
        getSubject().createIntent(notification);

        notification.isExact = false;
        notification.repeatInterval = 0;
        getSubject().createIntent(notification);

        verify(intent, never()).putExtra(Constants.REPEAT_INTERVAL, LocalNotificationTimeInterval.MINUTE_CALENDAR_UNIT);
    }
}
