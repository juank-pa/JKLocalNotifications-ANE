package com.juankpro.ane.localnotif;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Bundle;

import com.juankpro.ane.localnotif.factory.NotificationFactory;
import com.juankpro.ane.localnotif.factory.NotificationPendingIntentFactory;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Created by juancarlospazmino on 12/14/17.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({NotificationDispatcher.class})
public class NotificationDispatcherTest {
    @Mock
    private Bundle bundle;
    @Mock
    private Context context;
    @Mock
    private SoundSettings soundSettings;
    @Mock
    private NotificationManager notificationManager;
    @Mock
    private NotificationFactory notificationFactory;
    @Mock
    private NotificationPendingIntentFactory pendingIntentFactory;
    @Mock
    private Notification notification;

    private NotificationDispatcher subject;
    private NotificationDispatcher getSubject() {
        if (subject == null) { subject = new NotificationDispatcher(context, bundle); }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        String code = "testCode";
        when(bundle.getString(Constants.NOTIFICATION_CODE_KEY)).thenReturn(code);
        when(context.getSystemService(Context.NOTIFICATION_SERVICE)).thenReturn(notificationManager);
        when(notificationFactory.create(pendingIntentFactory)).thenReturn(notification);

        try {
            PowerMockito.whenNew(SoundSettings.class)
                    .withArguments(bundle)
                    .thenReturn(soundSettings);
            PowerMockito.whenNew(NotificationFactory.class)
                    .withArguments(context, bundle)
                    .thenReturn(notificationFactory);
            PowerMockito.whenNew(NotificationPendingIntentFactory.class)
                    .withArguments(context, bundle)
                    .thenReturn(pendingIntentFactory);
        } catch (Throwable e) { e.printStackTrace(); }
    }

    @Test
    public void dispatcher_dispatch_whenAppIsInForeground_andNormalNotification_doesNotDisplayNotification() {
        getSubject().dispatch();
        verify(notificationManager).notify("testCode", Constants.STANDARD_NOTIFICATION_ID, notification);
    }
}
