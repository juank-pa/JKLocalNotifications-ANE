package com.juankpro.ane.localnotif;

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

import static org.mockito.Mockito.never;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Created by juank on 12/18/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({AlarmRestoreOnBoot.class,Date.class})
public class AlarmRestoreOnBootTest {
    @Mock
    private Context context;
    @Mock
    private Intent intent;
    @Mock
    private Date now;
    @Mock
    private Date future;
    @Mock
    private Date past;
    @Mock
    private PersistenceManager persistenceManager;
    @Mock
    private LocalNotificationManager notificationManager;
    @Mock
    private LocalNotification notification1;
    @Mock
    private LocalNotification notification2;

    private AlarmRestoreOnBoot subject;
    private AlarmRestoreOnBoot getSubject() {
        if (subject == null) {
            subject = spy(new AlarmRestoreOnBoot());
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        Set<String> ids = new HashSet<>();

        try {
            PowerMockito.whenNew(PersistenceManager.class)
                    .withArguments(context)
                    .thenReturn(persistenceManager);
            PowerMockito.whenNew(Date.class)
                    .withNoArguments()
                    .thenReturn(now);
            PowerMockito.whenNew(LocalNotificationManager.class)
                    .withArguments(context)
                    .thenReturn(notificationManager);
        } catch (Throwable e) { e.printStackTrace(); }

        when(now.getTime()).thenReturn(100L);

        when(persistenceManager.readNotificationKeys()).thenReturn(ids);
        when(intent.getAction()).thenReturn(Intent.ACTION_BOOT_COMPLETED);
    }

    @Test
    public void provider_onReceive_doesNothing_ifNotRightPermission() {
        when(intent.getAction()).thenReturn("any.other.permission");
        getSubject().onReceive(context, intent);
        verify(persistenceManager, never()).readNotificationKeys();
    }

    private void initNotifications() {
        Set<String> ids = new HashSet<>();
        ids.add("NOTIF1");
        ids.add("NOTIF2");

        notification1.code = "NOTIF1";
        notification2.code = "NOTIF2";

        when(persistenceManager.readNotification("NOTIF1")).thenReturn(notification1);
        when(persistenceManager.readNotification("NOTIF2")).thenReturn(notification2);

        notification1.fireDate = future;
        notification2.fireDate = past;

        when(future.getTime()).thenReturn(200L);
        when(past.getTime()).thenReturn(20L);

        when(persistenceManager.readNotificationKeys()).thenReturn(ids);
    }

    @Test
    public void provider_onReceive_notifiesEventsInTheFuture() {
        initNotifications();
        getSubject().onReceive(context, intent);
        verify(notificationManager).notify(notification1);
    }

    @Test
    public void provider_onReceive_removesEventsInThePast() {
        initNotifications();
        getSubject().onReceive(context, intent);
        verify(persistenceManager).removeNotification("NOTIF2");
    }
}