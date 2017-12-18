package com.juankpro.ane.localnotif;

import android.app.AlarmManager;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;

import com.juankpro.ane.localnotif.factory.NotificationRequestIntentFactory;
import com.juankpro.ane.localnotif.util.PersistenceManager;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import java.util.HashSet;
import java.util.Set;

import static org.mockito.Mockito.mock;
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
    @Mock
    private NotificationRequestIntentFactory intentFactory;
    private LocalNotification notification = new LocalNotification("ClassName");
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
            PowerMockito.whenNew(NotificationRequestIntentFactory.class)
                    .withArguments(context)
                    .thenReturn(intentFactory);
        } catch (Throwable e) { e.printStackTrace(); }

        when(context.getSystemService(Context.NOTIFICATION_SERVICE)).thenReturn(notificationManager);
        when(context.getSystemService(Context.ALARM_SERVICE)).thenReturn(alarmManager);
        when(intentFactory.createIntent(notification)).thenReturn(intent);
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
        verify(intentFactory).createIntent(notification);
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
