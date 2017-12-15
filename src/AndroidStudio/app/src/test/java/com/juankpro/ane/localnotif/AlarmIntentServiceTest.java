package com.juankpro.ane.localnotif;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;


/**
 * Created by jpazmino on 11/10/17.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({AlarmIntentService.class})
public class AlarmIntentServiceTest {
    @Mock
    private Context context;
    @Mock
    private Bundle bundle;
    @Mock
    private Intent intent;
    @Mock
    private LocalNotificationEventDispatcher eventDispatcher;
    @Mock
    private NotificationDispatcher notificationDispatcher;
    private byte[] data = new byte[]{};
    private AlarmIntentService subject;

    private AlarmIntentService getSubject() {
        if (subject == null) {
            subject = new AlarmIntentService();
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);

        when(intent.getExtras()).thenReturn(bundle);

        when(bundle.getString(Constants.NOTIFICATION_CODE_KEY)).thenReturn("KeyCode");
        when(bundle.getByteArray(Constants.ACTION_DATA_KEY)).thenReturn(data);

        try {
            PowerMockito.whenNew(LocalNotificationEventDispatcher.class)
                    .withArguments("KeyCode", data, null)
                    .thenReturn(eventDispatcher);
        } catch(Exception e) { e.printStackTrace(); }
    }

    @Test
    public void intentService_onReceiveWhenAppIsInForeground_andNormalNotification_doesNotDispatchNotification() {
        when(eventDispatcher.dispatchWhenInForeground()).thenReturn(true);
        getSubject().onReceive(context, intent);

        verify(notificationDispatcher, never()).dispatch();
    }

    private void mockNotificationDispatch() {
        try {
            PowerMockito.whenNew(NotificationDispatcher.class).withArguments(context, bundle)
                    .thenReturn(notificationDispatcher);
        } catch(Exception e) { e.printStackTrace(); }
    }


    @Test
    public void intentService_onReceiveWhenAppIsNotInForeground_andNormalNotification_dispatchesNotification() {
        when(eventDispatcher.dispatchWhenInForeground()).thenReturn(false);

        mockNotificationDispatch();

        getSubject().onReceive(context, intent);

        verify(notificationDispatcher).dispatch();
    }

    @Test
    public void intentService_onReceiveWhenNotificationShowsInForeground_dispatchesNotification() {
        when(eventDispatcher.dispatchWhenInForeground()).thenReturn(true);
        when(bundle.getBoolean(Constants.SHOW_IN_FOREGROUND)).thenReturn(true);

        mockNotificationDispatch();

        getSubject().onReceive(context, intent);

        verify(notificationDispatcher).dispatch();
        verify(eventDispatcher, never()).dispatchWhenInForeground();
    }
}
