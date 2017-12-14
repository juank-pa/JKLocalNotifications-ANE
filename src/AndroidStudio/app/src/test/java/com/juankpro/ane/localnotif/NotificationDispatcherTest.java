package com.juankpro.ane.localnotif;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.juankpro.ane.localnotif.factory.NotificationFactory;
import com.juankpro.ane.localnotif.factory.NotificationPendingIntentFactory;
import com.juankpro.ane.localnotif.util.PlayAudio;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
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
    private String code = "testCode";

    private NotificationDispatcher subject;
    private NotificationDispatcher getSubject() {
        if (subject == null) { subject = new NotificationDispatcher(context, bundle); }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
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
    public void dispatcher_dispatch_WhenAppIsInForeground_andNormalNotification_doesNotDisplayNotification() {
        getSubject().dispatch();
        verify(notificationManager).notify("testCode", Constants.STANDARD_NOTIFICATION_ID, notification);
    }

    @Test
    public void dispatcher_dispatch_doesNotPlaySoundIfCustomSoundShouldNotPlay() {
        getSubject().dispatch();
        verify(context, never()).startService(any(Intent.class));
    }

    @Test
    public void dispatcher_dispatch_PlaysSoundIfCustomSoundShouldPlay() {
        Intent intent = mock(Intent.class);
        when(soundSettings.shouldPlayCustomSound()).thenReturn(true);
        when(soundSettings.getSoundName()).thenReturn("sound.mp3");

        try {
            PowerMockito.whenNew(Intent.class)
                    .withArguments(context, PlayAudio.class)
                    .thenReturn(intent);
            PowerMockito.whenNew(NotificationFactory.class)
                    .withArguments(context, bundle)
                    .thenReturn(notificationFactory);
            PowerMockito.whenNew(NotificationPendingIntentFactory.class)
                    .withArguments(context, bundle)
                    .thenReturn(pendingIntentFactory);
        } catch (Throwable e) { e.printStackTrace(); }

        getSubject().dispatch();
        verify(intent).putExtra(Constants.SOUND_NAME, "sound.mp3");
        verify(context).startService(intent);
    }
}
