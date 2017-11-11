package com.juankpro.ane.localnotif;

import android.app.Notification;
import android.app.PendingIntent;
import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import static org.junit.Assert.*;

/**
 * Created by Juank on 11/9/17.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({NotificationFactory.class})
public class NotificationFactoryTest {
    @Mock
    private Context context;
    @Mock
    private Bundle bundle;
    @Mock
    private NotificationCompat.Builder builder;
    @Mock
    private PendingIntent pendingIntent;
    @Mock
    private NotificationIntentFactory intentFactory;
    @Mock
    private NotificationCompat.BigTextStyle textStyle;
    private Notification notification = new Notification();
    private NotificationFactory subject;

    private NotificationFactory getSubject() {
        if (subject == null) {
            subject = new NotificationFactory(context, bundle);
        }
        return subject;
    }

    private void setup() {
        MockitoAnnotations.initMocks(this);

        try {
            PowerMockito.whenNew(NotificationCompat.Builder.class).withArguments(context).thenReturn(builder);
        } catch(Exception e) { e.printStackTrace(); }

        when(bundle.getInt(Constants.NUMBER_ANNOTATION)).thenReturn(10);
        when(bundle.getInt(Constants.ICON_RESOURCE)).thenReturn(1001);
        when(bundle.getString(Constants.TICKER_TEXT)).thenReturn("Ticker text");
        when(bundle.getString(Constants.TITLE)).thenReturn("Title");
        when(bundle.getString(Constants.BODY)).thenReturn("Body");
        when(bundle.getString(Constants.NOTIFICATION_CODE_KEY)).thenReturn("MyCode");

        when(builder.setContentTitle(any(CharSequence.class))).thenReturn(builder);
        when(builder.setContentText(any(CharSequence.class))).thenReturn(builder);
        when(builder.setSmallIcon(anyInt())).thenReturn(builder);
        when(builder.setTicker(any(CharSequence.class))).thenReturn(builder);
        when(builder.setDefaults(anyInt())).thenReturn(builder);
        when(builder.setNumber(anyInt())).thenReturn(builder);
        when(builder.setStyle(any(NotificationCompat.Style.class))).thenReturn(builder);
        when(builder.setOngoing(anyBoolean())).thenReturn(builder);
        when(builder.setAutoCancel(anyBoolean())).thenReturn(builder);
        when(builder.setOnlyAlertOnce(anyBoolean())).thenReturn(builder);
        when(builder.setStyle(any(NotificationCompat.Style.class))).thenReturn(builder);
        when(builder.build()).thenReturn(notification);

        when(textStyle.bigText(anyString())).thenReturn(textStyle);

        when(intentFactory.createPendingIntent()).thenReturn(pendingIntent);
    }

    @Test
    public void factory_create_createsANotificationWithTheGivenInformation() {
        setup();
        Notification notification = getSubject().create(intentFactory);
        verify(builder).setSmallIcon(1001);
        verify(builder).setNumber(10);
        verify(builder).setTicker("Ticker text");
        verify(builder).setContentTitle("Title");
        verify(builder).setContentText("Body");
        assertSame(notification, this.notification);
    }

    @Test
    public void factory_create_createsWithBigTextLayout() {
        setup();

        try {
            PowerMockito.whenNew(NotificationCompat.BigTextStyle.class)
                    .withNoArguments().thenReturn(textStyle);
        } catch(Exception e) { e.printStackTrace(); }

        getSubject().create(intentFactory);
        verify(textStyle).bigText("Body");
        verify(builder).setStyle(textStyle);
    }

    @Test
    public void factory_create_createsWithDefaultSound() {
        setup();

        getSubject().create(intentFactory);
        verify(builder).setDefaults(Notification.DEFAULT_LIGHTS);

        when(bundle.getBoolean(Constants.PLAY_SOUND)).thenAnswer(new Answer<Boolean>() {
            public Boolean answer(InvocationOnMock invocation) {
                return true;
            }
        });

        getSubject().create(intentFactory);
        verify(builder).setDefaults(Notification.DEFAULT_SOUND | Notification.DEFAULT_LIGHTS);
    }

    @Test
    public void factory_create_createsWithDefaultVibration() {
        setup();

        when(bundle.getBoolean(Constants.VIBRATE)).thenAnswer(new Answer<Boolean>() {
            public Boolean answer(InvocationOnMock invocation) {
                return true;
            }
        });

        getSubject().create(intentFactory);
        verify(builder).setDefaults(Notification.DEFAULT_VIBRATE | Notification.DEFAULT_LIGHTS);
    }

    @Test
    public void factory_create_createsAsOngoing() {
        setup();

        getSubject().create(intentFactory);
        verify(builder).setOngoing(false);

        when(bundle.getBoolean(Constants.ON_GOING)).thenAnswer(new Answer<Boolean>() {
            public Boolean answer(InvocationOnMock invocation) {
                return true;
            }
        });

        getSubject().create(intentFactory);
        verify(builder).setOngoing(true);
    }

    @Test
    public void factory_create_createsAsAutoCancel() {
        setup();

        getSubject().create(intentFactory);
        verify(builder).setAutoCancel(false);

        when(bundle.getBoolean(Constants.CANCEL_ON_SELECT)).thenAnswer(new Answer<Boolean>() {
            public Boolean answer(InvocationOnMock invocation) {
                return true;
            }
        });

        getSubject().create(intentFactory);
        verify(builder).setAutoCancel(true);
    }

    @Test
    public void factory_create_createsToAlertOnlyOnceWithFirstTimePolicy() {
        setup();

        getSubject().create(intentFactory);
        verify(builder).setOnlyAlertOnce(false);

        when(bundle.getString(Constants.ALERT_POLICY)).thenAnswer(new Answer<String>() {
            public String answer(InvocationOnMock invocation) {
                return "firstNotification";
            }
        });

        getSubject().create(intentFactory);
        verify(builder).setOnlyAlertOnce(true);
    }

    @Test
    public void factory_create_createsToAlertOnlyOnceWithSomethingElse() {
        setup();

        when(bundle.getString(Constants.ALERT_POLICY)).thenAnswer(new Answer<String>() {
            public String answer(InvocationOnMock invocation) {
                return "somethingElse";
            }
        });

        getSubject().create(intentFactory);
        verify(builder).setOnlyAlertOnce(false);
    }

    @Test
    public void factory_create_createsWithAction() {
        setup();

        when(bundle.getBoolean(Constants.HAS_ACTION)).thenAnswer(new Answer<Boolean>() {
            public Boolean answer(InvocationOnMock invocation) {
                return true;
            }
        });


        getSubject().create(intentFactory);
        verify(builder).setContentIntent(pendingIntent);
    }
}