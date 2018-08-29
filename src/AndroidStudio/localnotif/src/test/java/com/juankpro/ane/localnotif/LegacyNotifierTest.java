package com.juankpro.ane.localnotif;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;

import com.juankpro.ane.localnotif.notifier.LegacyNotifier;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import java.util.Date;

import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.powermock.api.mockito.PowerMockito.mock;

@RunWith(PowerMockRunner.class)
@PrepareForTest({LegacyNotifier.class, LocalNotification.class})
public class LegacyNotifierTest {
    @Mock
    private Context context;
    @Mock
    private PendingIntent pendingIntent;
    @Mock
    private AlarmManager alarmManager;
    private LegacyNotifier subject;

    private LegacyNotifier getSubject() {
        if (subject == null) {
            subject = spy(new LegacyNotifier(context));
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        when(context.getSystemService(Context.ALARM_SERVICE)).thenReturn(alarmManager);
    }

    private LocalNotification getNotification() {
        LocalNotification notification = new LocalNotification();
        notification.fireDate = new Date(new Date().getTime() + 5000);
        return notification;
    }

    @Test
    public void notifier_notify_setsAlarm_whenExact_andNonIdle() {
        LocalNotification notification = getNotification();
        notification.isExact = true;
        notification.allowWhileIdle = false;
        getSubject().notify(notification.fireDate.getTime(), pendingIntent, notification);

        verify(alarmManager).set(AlarmManager.RTC_WAKEUP, notification.fireDate.getTime(), pendingIntent);
    }

    @Test
    public void notifier_notify_setsAlarm_whenNonExact_andNonIdle() {
        LocalNotification notification = getNotification();
        notification.isExact = false;
        notification.allowWhileIdle = false;
        getSubject().notify(notification.fireDate.getTime(), pendingIntent, notification);

        verify(alarmManager).set(AlarmManager.RTC_WAKEUP, notification.fireDate.getTime(), pendingIntent);
    }

    @Test
    public void notifier_notify_setsAlarm_whenExact_andIdle() {
        LocalNotification notification = getNotification();
        notification.isExact = true;
        notification.allowWhileIdle = true;
        getSubject().notify(notification.fireDate.getTime(), pendingIntent, notification);

        verify(alarmManager).set(AlarmManager.RTC_WAKEUP, notification.fireDate.getTime(), pendingIntent);
    }

    @Test
    public void notifier_notify_setsAlarm_whenNonExact_andIdle() {
        LocalNotification notification = getNotification();
        notification.isExact = false;
        notification.allowWhileIdle = true;
        getSubject().notify(notification.fireDate.getTime(), pendingIntent, notification);

        verify(alarmManager).set(AlarmManager.RTC_WAKEUP, notification.fireDate.getTime(), pendingIntent);
    }

    @Test
    public void notifier_notifyRepeating_setsRepeatingAlarm_whenNotificationDoesNotRepeatRecurrently() {
        LegacyNotifier subject = getSubject();

        LocalNotification notification = mock(LocalNotification.class);
        when(notification.repeatsRecurrently()).thenReturn(false);
        subject.notifyRepeating(300, 100, pendingIntent, notification);

        verify(alarmManager).setInexactRepeating(AlarmManager.RTC_WAKEUP, 300, 100, pendingIntent);
    }

    @Test
    public void notifier_notifyRepeating_setsAlarm_whenNotificationRepeatsRecurrently() {
        LegacyNotifier subject = spy(getSubject());

        LocalNotification notification = mock(LocalNotification.class);
        when(notification.repeatsRecurrently()).thenReturn(true);
        subject.notifyRepeating(300, 100, pendingIntent, notification);

        verify(subject).notify(300, pendingIntent, notification);
    }
}
