package com.juankpro.ane.localnotif;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import static org.junit.Assert.*;

/**
 * Created by Juank on 11/9/17.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({NotificationIntentFactory.class,PendingIntent.class})
public class NotificationIntentFactoryTest {
    @Mock
    private Context context;
    @Mock
    private Bundle bundle;
    @Mock
    private Intent intent;
    @Mock
    private PendingIntent pendingIntent;
    private byte[] bytes = new byte[]{};
    private NotificationIntentFactory subject;

    private NotificationIntentFactory getSubject() {
        if (subject == null) {
            subject = new NotificationIntentFactory(context, bundle);
        }
        return subject;
    }

    private void setup() {
        MockitoAnnotations.initMocks(this);

        when(bundle.getString(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY)).thenReturn("ActivityClassName");
        when(bundle.getString(Constants.NOTIFICATION_CODE_KEY)).thenReturn("MyCode");
        when(bundle.getByteArray(Constants.ACTION_DATA_KEY)).thenReturn(bytes);

        try {
            PowerMockito.whenNew(Intent.class).withNoArguments().thenReturn(intent);
        } catch(Exception e) { e.printStackTrace(); }

        PowerMockito.mockStatic(PendingIntent.class);
        when(PendingIntent.getService(context, "MyCode".hashCode(), intent, PendingIntent.FLAG_CANCEL_CURRENT))
                .thenReturn(pendingIntent);
    }

    @Test
    public void factory_createPendingIntent_createsPendingIntent() {
        setup();

        assertSame(pendingIntent, getSubject().createPendingIntent());

        verify(intent).setClassName(context, Constants.NOTIFICATION_INTENT_SERVICE);
        verify(intent).putExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY, "ActivityClassName");
        verify(intent).putExtra(Constants.NOTIFICATION_CODE_KEY, "MyCode");
        verify(intent).putExtra(Constants.ACTION_DATA_KEY, bytes);
    }
}