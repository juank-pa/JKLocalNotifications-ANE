package com.juankpro.ane.localnotif;

import android.content.Context;
import android.content.Intent;

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
    private Intent closeIntent;
    @Mock
    private LocalNotificationEventDispatcher dispatcher;

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

        try {
            PowerMockito.whenNew(LocalNotificationEventDispatcher.class)
                    .withArguments("KeyCode", data, "ActionId")
                    .thenReturn(dispatcher);
            PowerMockito.whenNew(Intent.class).withNoArguments()
                    .thenReturn(intent);
            PowerMockito.whenNew(Intent.class).withArguments(Intent.ACTION_CLOSE_SYSTEM_DIALOGS)
                    .thenReturn(closeIntent);
        } catch(Exception e) { e.printStackTrace(); }

        doReturn(context).when(getSubject()).getApplicationContext();
        PowerMockito.doNothing().when(getSubject()).sendBroadcast(closeIntent);

        PowerMockito.mockStatic(ApplicationStatus.class);
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
    public void intentService_onHandleIntent_doesNotStartActivityWhenInForeground() {
        subject.onHandleIntent(intent);
        verify(context, never()).startActivity(any(Intent.class));
    }

    @Test
    public void intentService_onHandleIntent_startsActivityWhenNotInForeground() {
        when(ApplicationStatus.getInForeground()).thenReturn(false);
        when(intent.getStringExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY)).thenReturn("MainActivityClass");

        subject.onHandleIntent(intent);
        verify(intent).setClassName(context, "MainActivityClass");
        verify(intent).setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        verify(context).startActivity(intent);
    }
}
