package com.juankpro.ane.localnotif;

import android.app.AlarmManager;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;

import com.juankpro.ane.localnotif.util.PersistenceManager;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Created by juank on 11/26/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({LocalNotificationManager.class, PendingIntent.class, LocalNotificationTimeInterval.class})
public class LocalNotificationManagerTest {
    @Mock
    private Context context;
    @Mock
    private Intent intent;
    @Mock
    private PendingIntent pendingIntent;
    @Mock
    private NotificationManager notificationManager;
    @Mock
    private AlarmManager alarmManager;
    private LocalNotificationManager subject;

    private LocalNotificationManager getSubject() {
        if (subject == null) {
            subject = spy(new LocalNotificationManager(context));
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        PowerMockito.mockStatic(PendingIntent.class);
        try {
            PowerMockito.whenNew(Intent.class)
                    .withArguments(context, AlarmIntentService.class)
                    .thenReturn(intent);
        } catch (Throwable e) { e.printStackTrace(); }

        when(context.getSystemService(Context.NOTIFICATION_SERVICE)).thenReturn(notificationManager);
        when(context.getSystemService(Context.ALARM_SERVICE)).thenReturn(alarmManager);
    }

    private LocalNotification getNotification() {
        LocalNotification notification = new LocalNotification("ClassName");
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
    public void manager_notify_notifiesWithoutRepeatingIfIntervalIsZero() {
        when(PendingIntent.getBroadcast(context, "MyCode".hashCode(), intent, PendingIntent.FLAG_CANCEL_CURRENT))
                .thenReturn(pendingIntent);

        LocalNotification notification = getNotification();
        getSubject().notify(notification);

        verify(alarmManager).set(AlarmManager.RTC_WAKEUP, notification.fireDate.getTime(), pendingIntent);
    }

    @Test
    public void manager_notify_notifiesRepeatingIfIntervalIsGreaterThanZero() {
        when(PendingIntent.getBroadcast(context, "MyCode".hashCode(), intent, PendingIntent.FLAG_CANCEL_CURRENT))
                .thenReturn(pendingIntent);

        LocalNotification notification = getNotification();
        notification.repeatInterval = LocalNotificationTimeInterval.MINUTE_CALENDAR_UNIT;
        getSubject().notify(notification);

        verify(alarmManager).setRepeating(
                AlarmManager.RTC_WAKEUP,
                notification.fireDate.getTime(),
                notification.getRepeatIntervalMilliseconds(),
                pendingIntent
        );
    }

    @Test
    public void manager_notify_setsUpIntent() {
        getSubject().notify(getNotification());

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
    public void manager_notify_setsUpPlaySound() {
        LocalNotification notification = getNotification();
        notification.playSound = true;
        getSubject().notify(notification);
        verify(intent).putExtra(Constants.PLAY_SOUND, true);
    }

    @Test
    public void manager_notify_setsUpVibrate() {
        LocalNotification notification = getNotification();
        notification.vibrate = true;
        getSubject().notify(notification);
        verify(intent).putExtra(Constants.VIBRATE, true);
    }

    @Test
    public void manager_notify_setsUpCancelOngoing() {
        LocalNotification notification = getNotification();
        notification.ongoing = true;
        getSubject().notify(notification);
        verify(intent).putExtra(Constants.ON_GOING, true);
    }

    @Test
    public void manager_notify_setsUpCancelOnSelect() {
        LocalNotification notification = getNotification();
        notification.cancelOnSelect = true;
        getSubject().notify(notification);
        verify(intent).putExtra(Constants.CANCEL_ON_SELECT, true);
    }

    @Test
    public void manager_notify_setsUpShowInForeground() {
        LocalNotification notification = getNotification();
        notification.showInForeground = true;
        getSubject().notify(notification);
        verify(intent).putExtra(Constants.SHOW_IN_FOREGROUND, true);
    }

    @Test
    public void manager_notify_setsActivityClassIfItHasAction() {
        LocalNotification notification = getNotification();
        notification.hasAction = true;
        getSubject().notify(notification);
        verify(intent).putExtra(Constants.HAS_ACTION, true);
        verify(intent).putExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY, "ClassName");
    }

    @Test
    public void manager_notify_doesNotSetActivityClassIfHasNoAction() {
        LocalNotification notification = getNotification();
        notification.hasAction = false;
        getSubject().notify(notification);
        verify(intent).putExtra(Constants.HAS_ACTION, false);
        verify(intent, never()).putExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY, "ClassName");
    }

    @Test
    public void manager_cancel_cancelsAllStoredAlarms() {
        when(PendingIntent.getBroadcast(context, "notif1".hashCode(), intent, PendingIntent.FLAG_CANCEL_CURRENT))
                .thenReturn(pendingIntent);

        getSubject().cancel("notif1");

        verify(intent).setAction("notif1");
        verify(alarmManager).cancel(pendingIntent);
    }

    @Test
    public void manager_cancelAll_cancelsAllStoredNotifications() {
        PersistenceManager persistenceManager = mock(PersistenceManager.class);
        Set<String> keys = new HashSet<>();
        keys.add("notif1");
        keys.add("notif2");

        try {
            PowerMockito.whenNew(PersistenceManager.class)
                    .withArguments(context)
                    .thenReturn(persistenceManager);
        } catch (Throwable e) { e.printStackTrace(); }
        when(persistenceManager.readNotificationKeys()).thenReturn(keys);

        getSubject().cancelAll();

        verify(getSubject()).cancel("notif1");
        verify(getSubject()).cancel("notif2");
    }
}
