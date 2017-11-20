package com.juankpro.ane.localnotif;

import android.content.Context;
import android.content.Intent;

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
@PrepareForTest({LocalNotificationIntentService.class,ApplicationStatus.class})
public class LocalNotificationIntentServiceTest {
    @Mock
    private Context context;
    @Mock
    private Intent intent;
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

    private void setup() {
        MockitoAnnotations.initMocks(this);

        when(intent.getStringExtra(Constants.NOTIFICATION_CODE_KEY)).thenReturn("KeyCode");
        when(intent.getByteArrayExtra(Constants.ACTION_DATA_KEY)).thenReturn(data);

        try {
            PowerMockito.whenNew(LocalNotificationEventDispatcher.class).withArguments("KeyCode", data)
                    .thenReturn(dispatcher);
            PowerMockito.whenNew(Intent.class).withNoArguments()
                    .thenReturn(intent);
        } catch(Exception e) { e.printStackTrace(); }

        doReturn(context).when(getSubject()).getApplicationContext();

        PowerMockito.mockStatic(ApplicationStatus.class);
        when(ApplicationStatus.getInForeground()).thenReturn(true);
    }

    @Test
    public void intentService_onHandleIntent_triesToDispatchEventToBackground() {
        setup();
        getSubject().onHandleIntent(intent);
        verify(dispatcher).dispatchWhenActive();
    }

    @Test
    public void intentService_onHandleIntent_doesNotStartActivityWhenInForeground() {
        setup();
        subject.onHandleIntent(intent);
        verify(context, never()).startActivity(any(Intent.class));
    }

    @Test
    public void intentService_onHandleIntent_startsActivityWhenNotInForeground() {
        setup();
        when(ApplicationStatus.getInForeground()).thenReturn(false);
        when(intent.getStringExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY)).thenReturn("MainActivityClass");

        subject.onHandleIntent(intent);
        verify(intent).setClassName(context, "MainActivityClass");
        verify(intent).setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        verify(context).startActivity(intent);
    }
}
