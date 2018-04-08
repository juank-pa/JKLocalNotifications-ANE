package com.juankpro.ane.localnotif;

import com.juankpro.ane.localnotif.util.ApplicationStatus;

import org.junit.Before;
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
    private String actionId = "ActionId";
    private String userResponse = "User Response";

    private LocalNotificationEventDispatcher getSubject() {
        if (subject == null) {
            subject = new LocalNotificationEventDispatcher(code, data, actionId, userResponse);
        }
        return subject;
    }

    @Before
    public void setup() {
        ApplicationStatus.reset();
        LocalNotificationCache.clear();
        MockitoAnnotations.initMocks(this);

        PowerMockito.mockStatic(LocalNotificationsContext.class);
        when(LocalNotificationsContext.getInstance()).thenReturn(context);
    }

    private void assertCache() {
        assertEquals(code, LocalNotificationCache.getInstance().getNotificationCode());
        assertEquals(data, LocalNotificationCache.getInstance().getNotificationData());
        assertEquals(actionId, LocalNotificationCache.getInstance().getActionId());
        assertEquals(userResponse, LocalNotificationCache.getInstance().getUserResponse());
        assertTrue(LocalNotificationCache.getInstance().wasUpdated());
    }

    @Test
    public void dispatcher_dispatchInForeground_setsCacheIfAppIsNotActive() {
        getSubject().dispatchWhenInForeground();
        assertCache();
    }

    @Test
    public void dispatcher_dispatchInForeground_doesNotDispatchesIfAppIsNotActive() {
        getSubject().dispatchWhenInForeground();
        verify(context, never()).dispatchNotificationSelectedEvent();
    }

    @Test
    public void dispatcher_dispatchInForeground_setsCacheIfAppIsInBackground() {
        ApplicationStatus.setInForeground(true);
        ApplicationStatus.setInForeground(false);
        getSubject().dispatchWhenInForeground();
        assertCache();
    }

    @Test
    public void dispatcher_dispatchInForeground_doesNotDispatchIfAppIsInBackground() {
        ApplicationStatus.reset();
        ApplicationStatus.activate();
        getSubject().dispatchWhenInForeground();
        verify(context, never()).dispatchNotificationSelectedEvent();
    }

    @Test
    public void dispatcher_dispatchInForeground_setsCacheIfAppIsInForeground() {
        ApplicationStatus.setInForeground(true);
        getSubject().dispatchWhenInForeground();
        assertCache();
    }

    @Test
    public void dispatcher_dispatchInForeground_dispatchesIfAppIsInForeground() {
        ApplicationStatus.setInForeground(true);
        getSubject().dispatchWhenInForeground();
        verify(context).dispatchNotificationSelectedEvent();
    }
    @Test
    public void dispatcher_dispatchWhenActive_setsCacheIfAppIsNotActive() {
        getSubject().dispatchWhenActive();
        assertCache();
    }

    @Test
    public void dispatcher_dispatchWhenActive_doesNotDispatchIfAppIsNotActive() {
        getSubject().dispatchWhenActive();
        verify(context, never()).dispatchNotificationSelectedEvent();
    }

    @Test
    public void dispatcher_dispatchWhenActive_setsCacheIfAppIsInBackground() {
        ApplicationStatus.setInForeground(true);
        ApplicationStatus.setInForeground(false);
        getSubject().dispatchWhenActive();
        assertCache();
    }

    @Test
    public void dispatcher_dispatchWhenActive_dispatchesIfAppIsInBackground() {
        ApplicationStatus.reset();
        ApplicationStatus.activate();
        getSubject().dispatchWhenActive();
        verify(context).dispatchNotificationSelectedEvent();
    }

    @Test
    public void dispatcher_dispatchWhenActive_setsCacheIfAppIsInForeground() {
        ApplicationStatus.setInForeground(true);
        getSubject().dispatchWhenActive();
        assertCache();
    }

    @Test
    public void dispatcher_dispatchWhenActive_dispatchesIfAppIsInForeground() {
        ApplicationStatus.setInForeground(true);
        getSubject().dispatchWhenActive();
        verify(context).dispatchNotificationSelectedEvent();
    }
}
