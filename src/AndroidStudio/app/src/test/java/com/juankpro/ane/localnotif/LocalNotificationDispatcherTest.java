package com.juankpro.ane.localnotif;

import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

/**
 * Created by Juank on 10/24/17.
 */

public class LocalNotificationDispatcherTest {
    @Mock private LocalNotificationsContext context;
    private LocalNotificationDispatcher subject;
    private String code = "My Code";
    private byte[] data = new byte[]{0};

    private LocalNotificationDispatcher getSubject() {
        if (subject == null) {
            subject = new LocalNotificationDispatcher(context, code, data);
        }
        return subject;
    }

    private void setup() {
        ApplicationStatus.reset();
        LocalNotificationCache.clear();
        MockitoAnnotations.initMocks(this);
    }

    @Test
    public void dispatcher_initializedWithoutContext_generatesADefaultOne() {
        LocalNotificationDispatcher dispatcher = new LocalNotificationDispatcher(code, data);
        assertNotSame(context, dispatcher.getNotificationContext());
    }

    @Test
    public void dispatcher_initializedWithContext_usesGivenContext() {
        setup();
        assertSame(getSubject().getNotificationContext(), context);
    }

    private void assertCache() {
        assertEquals(LocalNotificationCache.getInstance().getNotificationCode(), code);
        assertEquals(LocalNotificationCache.getInstance().getNotificationData(), data);
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
