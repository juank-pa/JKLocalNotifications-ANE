package com.juankpro.ane.localnotif;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.juankpro.ane.localnotif.factory.NotificationPendingIntentFactory;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import static org.junit.Assert.*;

/**
 * Created by Juank on 11/9/17.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({NotificationPendingIntentFactory.class,PendingIntent.class})
public class NotificationPendingIntentFactoryTest {
    @Mock
    private Context context;
    @Mock
    private Bundle bundle;
    @Mock
    private Intent intent;
    @Mock
    private PendingIntent pendingIntent;
    private byte[] bytes = new byte[]{};
    private NotificationPendingIntentFactory subject;

    private NotificationPendingIntentFactory getSubject() {
        if (subject == null) {
            subject = new NotificationPendingIntentFactory(context, bundle);
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);

        when(bundle.getString(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY)).thenReturn("ActivityClassName");
        when(bundle.getString(Constants.NOTIFICATION_CODE_KEY)).thenReturn("MyCode");
        when(bundle.getByteArray(Constants.ACTION_DATA_KEY)).thenReturn(bytes);

        try {
            PowerMockito.whenNew(Intent.class).withNoArguments().thenReturn(intent);
        } catch(Exception e) { e.printStackTrace(); }

        PowerMockito.mockStatic(PendingIntent.class);
    }

    @Test
    public void factory_createPendingIntent_createsPendingIntent() {
        when(PendingIntent.getService(context, "MyCode".hashCode(), intent, PendingIntent.FLAG_CANCEL_CURRENT))
                .thenReturn(pendingIntent);

        assertSame(pendingIntent, getSubject().createPendingIntent());

        verify(intent).setClassName(context, Constants.NOTIFICATION_INTENT_SERVICE);
        verify(intent).putExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY, "ActivityClassName");
        verify(intent).putExtra(Constants.NOTIFICATION_CODE_KEY, "MyCode");
        verify(intent).putExtra(Constants.ACTION_DATA_KEY, bytes);
        verify(intent, never()).putExtra(eq(Constants.ACTION_ID_KEY), anyString());
    }

    @Test
    public void factory_createPendingIntent_createsPendingIntentForAction() {
        when(PendingIntent.getService(context, "MyCodeActionId".hashCode(), intent, PendingIntent.FLAG_CANCEL_CURRENT))
                .thenReturn(pendingIntent);

        assertSame(pendingIntent, getSubject().createPendingIntent("ActionId", false));

        verify(intent).setClassName(context, Constants.NOTIFICATION_INTENT_SERVICE);
        verify(intent).putExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY, "ActivityClassName");
        verify(intent).putExtra(Constants.NOTIFICATION_CODE_KEY, "MyCode");
        verify(intent).putExtra(Constants.ACTION_DATA_KEY, bytes);
        verify(intent).putExtra(Constants.ACTION_ID_KEY, "ActionId");
        verify(intent).putExtra(Constants.BACKGROUND_MODE_ID_KEY, false);
    }

    @Test
    public void factory_createPendingIntent_createsPendingIntentFoBackgroundAction() {
        when(PendingIntent.getService(context, "MyCodeActionId".hashCode(), intent, PendingIntent.FLAG_CANCEL_CURRENT))
                .thenReturn(pendingIntent);

        assertSame(pendingIntent, getSubject().createPendingIntent("ActionId", true));

        verify(intent).setClassName(context, Constants.NOTIFICATION_INTENT_SERVICE);
        verify(intent).putExtra(Constants.MAIN_ACTIVITY_CLASS_NAME_KEY, "ActivityClassName");
        verify(intent).putExtra(Constants.NOTIFICATION_CODE_KEY, "MyCode");
        verify(intent).putExtra(Constants.ACTION_DATA_KEY, bytes);
        verify(intent).putExtra(Constants.ACTION_ID_KEY, "ActionId");
        verify(intent).putExtra(Constants.BACKGROUND_MODE_ID_KEY, true);
    }
}