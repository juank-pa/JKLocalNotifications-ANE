package com.juankpro.ane.localnotif;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

/**
 * Created by Juank on 10/24/17.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({LocalNotificationsContext.class})
public class LocalNotificationEventDispatcherTest {
    @Mock private LocalNotificationsContext context;
    private LocalNotificationEventDispatcher subject;
    private String code = "My Code";
    private byte[] data = new byte[]{0};

    private LocalNotificationEventDispatcher getSubject() {
        if (subject == null) {
            subject = new LocalNotificationEventDispatcher(code, data);
        }
        return subject;
    }

    private void setup() {
        ApplicationStatus.reset();
        LocalNotificationCache.clear();
        MockitoAnnotations.initMocks(this);

        PowerMockito.mockStatic(LocalNotificationsContext.class);
        when(LocalNotificationsContext.getInstance()).thenReturn(context);
    }

    private void assertCache() {
        assertEquals(code, LocalNotificationCache.getInstance().getNotificationCode());
        assertEquals(data, LocalNotificationCache.getInstance().getNotificationData());
        assertTrue(LocalNotificationCache.getInstance().wasUpdated());
    }

    @Test
    public void dispatcher_dispatchInForeground_setsCacheIfAppIsNotActive() {
        setup();
        getSubject().dispatchInForeground();
        assertCache();
    }

    @Test
    public void dispatcher_dispatchInForeground_doesNotDispatchesIfAppIsNotActive() {
        setup();
        getSubject().dispatchInForeground();
        verify(context, never()).dispatchNotificationSelectedEvent();
    }

    @Test
    public void dispatcher_dispatchInForeground_setsCacheIfAppIsInBackground() {
        setup();
        ApplicationStatus.setInForeground(true);
        ApplicationStatus.setInForeground(false);
        getSubject().dispatchInForeground();
        assertCache();
    }

    @Test
    public void dispatcher_dispatchInForeground_doesNotDispatchesIfAppIsInBackground() {
        setup();
        ApplicationStatus.reset();
        getSubject().dispatchInForeground();
        verify(context, never()).dispatchNotificationSelectedEvent();
    }

    @Test
    public void dispatcher_dispatchInForeground_setsCacheIfAppIsInForeground() {
        setup();
        ApplicationStatus.setInForeground(true);
        getSubject().dispatchInForeground();
        assertCache();
    }

    @Test
    public void dispatcher_dispatchInForeground_dispatchesIfAppIsInForeground() {
        setup();
        ApplicationStatus.setInForeground(true);
        getSubject().dispatchInForeground();
        verify(context).dispatchNotificationSelectedEvent();
    }
}
