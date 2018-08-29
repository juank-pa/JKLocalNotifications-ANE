package com.juankpro.ane.localnotif;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;

import com.juankpro.ane.localnotif.notifier.MarshmallowNotifier;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.powermock.api.mockito.PowerMockito.mock;

@RunWith(PowerMockRunner.class)
@PrepareForTest({MarshmallowNotifier.class})
public class MarshmallowNotifierTest {
    @Mock
    private Context context;
    @Mock
    private PendingIntent pendingIntent;
    @Mock
    private AlarmManager alarmManager;
    private MarshmallowNotifier subject;

    private MarshmallowNotifier getSubject() {
        if (subject == null) {
            subject = spy(new MarshmallowNotifier(context));
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        when(context.getSystemService(Context.ALARM_SERVICE)).thenReturn(alarmManager);
    }

    private LocalNotification getNotification() {
        return new LocalNotification();
    }

    @Test
    public void notifier_notify_setsAlarm_whenExact_andNonIdle() {
        LocalNotification notification = getNotification();
        notification.isExact = true;
        notification.allowWhileIdle = false;
        getSubject().notify(100, pendingIntent, notification);

        verify(alarmManager).setExact(AlarmManager.RTC_WAKEUP, 100, pendingIntent);
    }

    @Test
    public void notifier_notify_setsAlarm_whenNonExact_andNonIdle() {
        LocalNotification notification = getNotification();
        notification.isExact = false;
        notification.allowWhileIdle = false;
        getSubject().notify(100, pendingIntent, notification);

        verify(alarmManager).set(AlarmManager.RTC_WAKEUP, 100, pendingIntent);
    }

    @Test
    public void notifier_notify_setsAlarm_whenExact_andIdle() {
        LocalNotification notification = getNotification();
        notification.isExact = true;
        notification.allowWhileIdle = true;
        getSubject().notify(100, pendingIntent, notification);

        verify(alarmManager).setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, 100, pendingIntent);
    }

    @Test
    public void notifier_notify_setsAlarm_whenNonExact_andIdle() {
        LocalNotification notification = getNotification();
        notification.isExact = false;
        notification.allowWhileIdle = true;
        getSubject().notify(100, pendingIntent, notification);

        verify(alarmManager).setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, 100, pendingIntent);
    }

    @Test
    public void notifier_notifyRepeating_setsRepeatingAlarm_whenNotificationDoesNotRepeatRecurrently() {
        MarshmallowNotifier subject = getSubject();

        LocalNotification notification = mock(LocalNotification.class);
        when(notification.repeatsRecurrently()).thenReturn(false);
        subject.notifyRepeating(300, 100, pendingIntent, notification);

        verify(alarmManager).setInexactRepeating(AlarmManager.RTC_WAKEUP, 300, 100, pendingIntent);
    }

    @Test
    public void notifier_notifyRepeating_setsAlarm_whenNotificationRepeatsRecurrently() {
        MarshmallowNotifier subject = spy(getSubject());

        LocalNotification notification = mock(LocalNotification.class);
        when(notification.repeatsRecurrently()).thenReturn(true);
        subject.notifyRepeating(300, 100, pendingIntent, notification);

        verify(subject).notify(300, pendingIntent, notification);
    }
}
