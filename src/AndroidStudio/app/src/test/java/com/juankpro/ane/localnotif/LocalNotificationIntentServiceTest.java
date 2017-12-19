package com.juankpro.ane.localnotif;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.juankpro.ane.localnotif.util.ApplicationStatus;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Created by jpazmino on 11/10/17.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({LocalNotificationIntentService.class, ApplicationStatus.class})
public class LocalNotificationIntentServiceTest {
    @Mock
    private Context context;
    @Mock
    private Intent intent;
    @Mock
    private Bundle bundle;
    @Mock
    private Intent closeIntent;
    @Mock
    private LocalNotificationEventDispatcher dispatcher;
    @Mock
    private NotificationDispatcher notificationDispatcher;

    private byte[] data = new byte[]{};
    private LocalNotificationIntentService subject;

    private LocalNotificationIntentService getSubject() {
        if (subject == null) {
            subject = spy(new LocalNotificationIntentService());
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);

        when(intent.getStringExtra(Constants.NOTIFICATION_CODE_KEY)).thenReturn("KeyCode");
        when(intent.getByteArrayExtra(Constants.ACTION_DATA_KEY)).thenReturn(data);
        when(intent.getStringExtra(Constants.ACTION_ID_KEY)).thenReturn("ActionId");
        when(intent.getStringExtra(Constants.USER_RESPONSE_KEY)).thenReturn("User Response");
        when(intent.getExtras()).thenReturn(bundle);

        try {
            PowerMockito.whenNew(LocalNotificationEventDispatcher.class)
                    .withArguments("KeyCode", data, "ActionId", "User Response")
                    .thenReturn(dispatcher);
            PowerMockito.whenNew(Intent.class).withNoArguments()
                    .thenReturn(intent);
            PowerMockito.whenNew(Intent.class).withArguments(Intent.ACTION_CLOSE_SYSTEM_DIALOGS)
                    .thenReturn(closeIntent);
            PowerMockito.whenNew(NotificationDispatcher.class)
                    .withArguments(context, bundle)
                    .thenReturn(notificationDispatcher);
        } catch(Exception e) { e.printStackTrace(); }

        doReturn(context).when(getSubject()).getApplicationContext();
        PowerMockito.doNothing().when(getSubject()).sendBroadcast(closeIntent);

        PowerMockito.mockStatic(ApplicationStatus.class);
        when(ApplicationStatus.getActive()).thenReturn(true);
        when(ApplicationStatus.getInForeground()).thenReturn(true);
    }

    @Test
    public void intentService_onHandleIntent_closesDialogs() {
        getSubject().onHandleIntent(intent);
        verify(getSubject()).sendBroadcast(closeIntent);
    }

    @Test
    public void intentService_onHandleIntent_triesToDispatchEventToBackground() {
        getSubject().onHandleIntent(intent);
        verify(dispatcher).dispatchWhenActive();
    }

    @Test
    public void intentService_onHandleIntent_doesNotStartForegroundActivityWhenInForeground() {
        when(intent.getBooleanExtra(Constants.BACKGROUND_MODE_KEY, false)).thenReturn(false);
        subject.onHandleIntent(intent);
        verify(context, never()).startActivity(any(Intent.class));
    }

    @Test
    public void intentService_onHandleIntent_startsForegroundActivityWhenNotInForeground_andNotActive() {
        when(ApplicationStatus.getActive()).thenReturn(false);
        when(ApplicationStatus.getInForeground()).thenReturn(false);
        when(intent.getStringExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY)).thenReturn("MainActivityClass");

        subject.onHandleIntent(intent);
        verify(intent).setClassName(context, "MainActivityClass");
        verify(intent).setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        verify(context).startActivity(intent);
    }

    @Test
    public void intentService_onHandleIntent_startsForegroundActivityWhenNotInForeground_andActive() {
        when(ApplicationStatus.getInForeground()).thenReturn(false);
        when(intent.getStringExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY)).thenReturn("MainActivityClass");

        subject.onHandleIntent(intent);
        verify(intent).setClassName(context, "MainActivityClass");
        verify(intent).setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        verify(context).startActivity(intent);
    }

    @Test
    public void intentService_onHandleIntent_doesNotStartBackgroundActivityWhenInForeground() {
        when(intent.getBooleanExtra(Constants.BACKGROUND_MODE_KEY, false)).thenReturn(true);
        subject.onHandleIntent(intent);
        verify(context, never()).startActivity(any(Intent.class));
    }

    @Test
    public void intentService_onHandleIntent_doesNotStartBackgroundActivityWhenNotInForeground_andActive() {
        when(ApplicationStatus.getInForeground()).thenReturn(false);
        when(intent.getBooleanExtra(Constants.BACKGROUND_MODE_KEY, false)).thenReturn(true);
        subject.onHandleIntent(intent);
        verify(context, never()).startActivity(any(Intent.class));
    }

    @Test
    public void intentService_onHandleIntent_startsBackgroundActivityWhenNotInForeground_andNotActive() {
        when(ApplicationStatus.getActive()).thenReturn(false);
        when(ApplicationStatus.getInForeground()).thenReturn(false);
        when(intent.getBooleanExtra(Constants.BACKGROUND_MODE_KEY, false)).thenReturn(true);
        when(intent.getStringExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY)).thenReturn("MainActivityClass");

        subject.onHandleIntent(intent);

        verify(intent).setClassName(context, "MainActivityClass");
        verify(intent).setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        verify(context).startActivity(intent);
    }

    @Test
    public void intentService_onHandleIntent_dispatchesNotificationWhenUserResponsePresent() {
        when(intent.getStringExtra(Constants.USER_RESPONSE_KEY)).thenReturn("User Response");
        subject.onHandleIntent(intent);
        verify(notificationDispatcher).dispatch();
    }

    @Test
    public void intentService_onHandleIntent_doesNotDispatchNotificationWhenUserResponseNotPresent() {
        try {
            PowerMockito.whenNew(LocalNotificationEventDispatcher.class)
                    .withArguments("KeyCode", data, "ActionId", null)
                    .thenReturn(dispatcher);
        } catch(Exception e) { e.printStackTrace(); }

        when(intent.getStringExtra(Constants.USER_RESPONSE_KEY)).thenReturn(null);
        subject.onHandleIntent(intent);
        verify(notificationDispatcher, never()).dispatch();
    }
}
