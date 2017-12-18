package com.juankpro.ane.localnotif;

import android.app.Notification;
import android.app.RemoteInput;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import com.juankpro.ane.localnotif.factory.NotificationRequestIntentFactory;
import com.juankpro.ane.localnotif.util.PersistenceManager;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.powermock.reflect.Whitebox;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyBoolean;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Created by juank on 12/18/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({
        TextInputActionIntentService.class,
        Build.class,
        RemoteInput.class
})
public class TextInputActionIntentServiceTest {
    @Mock
    private Bundle bundle;
    @Mock
    private Context context;
    @Mock
    private Intent intent;
    @Mock
    private Intent notificationIntent;
    @Mock
    private PersistenceManager persistencemanager;
    @Mock
    private NotificationRequestIntentFactory notificationIntentFactory;
    @Mock
    private LocalNotification notification;

    private TextInputActionIntentService subject;
    private TextInputActionIntentService getSubject() {
        if (subject == null) { subject = new TextInputActionIntentService(); }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);

        when(intent.getStringExtra(Constants.NOTIFICATION_CODE_KEY)).thenReturn("MyCode");
        when(intent.getExtras()).thenReturn(bundle);

        try {
            PowerMockito.whenNew(PersistenceManager.class)
                    .withArguments(context)
                    .thenReturn(persistencemanager);
            PowerMockito.whenNew(NotificationRequestIntentFactory.class)
                    .withArguments(context)
                    .thenReturn(notificationIntentFactory);
        } catch (Throwable e) { e.printStackTrace(); }

        when(persistencemanager.readNotification("MyCode")).thenReturn(notification);
        when(notificationIntentFactory.createIntent(notification)).thenReturn(notificationIntent);

        when(notificationIntent.setClass(any(Context.class), any(Class.class))).thenReturn(notificationIntent);
        when(notificationIntent.putExtra(anyString(), anyBoolean())).thenReturn(notificationIntent);
        when(notificationIntent.putExtra(anyString(), anyInt())).thenReturn(notificationIntent);
        when(notificationIntent.putExtras(any(Bundle.class))).thenReturn(notificationIntent);
    }

    @Test
    public void service_onReceive_startsService() {
        getSubject().onReceive(context, intent);
        verify(notificationIntent).setClass(context, LocalNotificationIntentService.class);
        verify(context).startService(notificationIntent);
    }

    @Test
    public void service_onReceive_tonesDownNotificationService() {
        getSubject().onReceive(context, intent);
        verify(notificationIntent).putExtra(Constants.VIBRATE, false);
        verify(notificationIntent).putExtra(Constants.PLAY_SOUND, false);
        verify(notificationIntent).putExtra(Constants.PRIORITY, Notification.PRIORITY_DEFAULT);
    }

    @Test
    public void service_onReceive_mergesIntentIntoNotificationIntent() {
        getSubject().onReceive(context, intent);
        verify(notificationIntent).putExtras(bundle);
    }

    @Test
    public void service_onReceive_onLessThanNougat_doesNotMergeIntentIntoNotificationIntent() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.N - 1);

        getSubject().onReceive(context, intent);
        verify(notificationIntent, never()).putExtra(eq(Constants.USER_RESPONSE_KEY), anyString());
    }

    @Test
    public void service_onReceive_noNougatOrHigher_mergesUserResponseIntoNotificationIntent() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.N);
        Bundle resultsBundle = mock(Bundle.class);
        PowerMockito.mockStatic(RemoteInput.class);
        when(RemoteInput.getResultsFromIntent(intent)).thenReturn(resultsBundle);
        when(resultsBundle.getString(Constants.USER_RESPONSE_KEY)).thenReturn("User Response");

        getSubject().onReceive(context, intent);
        verify(notificationIntent).putExtra(Constants.USER_RESPONSE_KEY, "User Response");
    }
}
