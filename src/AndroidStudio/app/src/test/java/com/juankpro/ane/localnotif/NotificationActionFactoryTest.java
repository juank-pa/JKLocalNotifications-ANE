package com.juankpro.ane.localnotif;

import android.app.PendingIntent;
import android.support.v4.app.NotificationCompat;
import android.support.v4.app.RemoteInput;

import com.juankpro.ane.localnotif.category.LocalNotificationAction;
import com.juankpro.ane.localnotif.factory.PendingIntentFactory;
import com.juankpro.ane.localnotif.factory.NotificationActionFactory;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.junit.Assert.assertSame;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Created by juank on 12/18/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({
        NotificationActionFactory.class,
        NotificationCompat.Action.Builder.class,
        RemoteInput.class
})
public class NotificationActionFactoryTest {
    @Mock
    private PendingIntentFactory intentFactory;
    @Mock
    private PendingIntent pendingIntent;
    @Mock
    private NotificationCompat.Action nativeAction;
    @Mock
    private RemoteInput.Builder remoteInputBuilder;
    private RemoteInput remoteInput;
    private NotificationCompat.Action.Builder builder;

    private NotificationActionFactory subject;
    private NotificationActionFactory getSubject() {
        if (subject == null) { subject = new NotificationActionFactory(intentFactory); }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        builder = PowerMockito.mock(NotificationCompat.Action.Builder.class);
        remoteInput = PowerMockito.mock(RemoteInput.class);
        when(builder.build()).thenReturn(nativeAction);

        try {
            PowerMockito.whenNew(NotificationCompat.Action.Builder.class)
                    .withArguments(10, "Title", pendingIntent)
                    .thenReturn(builder);
        } catch (Throwable e) { e.printStackTrace(); }
    }

    public LocalNotificationAction getAction() {
        return getAction(0, null);
    }

    public LocalNotificationAction getAction(int icon, String title) {
        LocalNotificationAction action = new LocalNotificationAction();
        action.identifier = "ActionId";
        action.icon = icon;
        action.title = title;
        action.isBackground = true;
        return action;
    }

    @Test
    public void factory_create_createsNativeAction() {
        LocalNotificationAction action = getAction(10, "Title");
        when(intentFactory.createActionPendingIntent("ActionId", true)).thenReturn(pendingIntent);

        assertSame(getSubject().create(action), nativeAction);
    }

    @Test
    public void factory_create_createsNativeTextInputAction() {
        LocalNotificationAction action = spy(getAction(10, "Title"));
        when(action.isTextInput()).thenReturn(true);
        when(intentFactory.createTextInputActionPendingIntent("ActionId", true)).thenReturn(pendingIntent);

        assertSame(getSubject().create(action), nativeAction);
    }

    @Test
    public void factory_create_addsRemoteInputToAction() {
        try {
            PowerMockito.whenNew(RemoteInput.Builder.class)
                    .withArguments(Constants.USER_RESPONSE_KEY)
                    .thenReturn(remoteInputBuilder);
        } catch (Throwable e) { e.printStackTrace(); }

        LocalNotificationAction action = spy(getAction(10, "Title"));
        action.textInputPlaceholder = "Placeholder";
        when(action.isTextInput()).thenReturn(true);
        when(remoteInputBuilder.setLabel("Placeholder")).thenReturn(remoteInputBuilder);
        when(remoteInputBuilder.build()).thenReturn(remoteInput);
        when(intentFactory.createTextInputActionPendingIntent("ActionId", true)).thenReturn(pendingIntent);

        assertSame(getSubject().create(action), nativeAction);
        verify(builder).addRemoteInput(remoteInput);
        verify(remoteInputBuilder).setLabel("Placeholder");
    }
}