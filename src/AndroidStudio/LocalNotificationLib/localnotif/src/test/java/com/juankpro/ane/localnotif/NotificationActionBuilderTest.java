package com.juankpro.ane.localnotif;

import android.app.Notification;
import android.app.PendingIntent;
import android.app.RemoteInput;
import android.os.Build;

import com.juankpro.ane.localnotif.category.LocalNotificationAction;
import com.juankpro.ane.localnotif.factory.PendingIntentFactory;
import com.juankpro.ane.localnotif.factory.NotificationActionBuilder;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.powermock.reflect.Whitebox;

import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Created by juank on 12/18/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({
        NotificationActionBuilder.class,
        Notification.Action.Builder.class,
        RemoteInput.class,
        Build.VERSION.class
})
public class NotificationActionBuilderTest {
    @Mock
    private PendingIntentFactory intentFactory;
    @Mock
    private PendingIntent pendingIntent;
    @Mock
    private Notification.Action nativeAction;
    @Mock
    private RemoteInput.Builder remoteInputBuilder;
    @Mock
    private RemoteInput remoteInput;
    @Mock
    private Notification.Action.Builder builder;
    @Mock
    private Notification.Builder notificationBuilder;

    private NotificationActionBuilder subject;
    private NotificationActionBuilder getSubject() {
        if (subject == null) { subject = new NotificationActionBuilder(intentFactory, notificationBuilder); }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        when(builder.build()).thenReturn(nativeAction);

        try {
            PowerMockito.whenNew(Notification.Action.Builder.class)
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
    public void factory_build_buildsNativeActionUsingActionBuilderClass() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.KITKAT_WATCH);
        LocalNotificationAction action = getAction(10, "Title");
        when(intentFactory.createActionPendingIntent("ActionId", true)).thenReturn(pendingIntent);

        getSubject().build(action);

        verify(notificationBuilder).addAction(nativeAction);
    }

    @Test
    public void factory_build_buildsNativeActionUsingBuildActionMethod() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.KITKAT_WATCH - 1);
        LocalNotificationAction action = getAction(10, "Title");
        when(intentFactory.createActionPendingIntent("ActionId", true)).thenReturn(pendingIntent);

        getSubject().build(action);

        verify(notificationBuilder).addAction(10, "Title", pendingIntent);
    }

    @Test
    public void factory_build_createsNativeTextInputAction() {
        try {
            PowerMockito.whenNew(RemoteInput.Builder.class)
                    .withArguments(Constants.USER_RESPONSE_KEY)
                    .thenReturn(remoteInputBuilder);
        } catch (Throwable e) { e.printStackTrace(); }
        when(remoteInputBuilder.setLabel(null)).thenReturn(remoteInputBuilder);
        when(remoteInputBuilder.build()).thenReturn(remoteInput);

        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.KITKAT_WATCH);
        LocalNotificationAction action = spy(getAction(10, "Title"));
        when(action.isTextInput()).thenReturn(true);
        when(intentFactory.createTextInputActionPendingIntent("ActionId", true)).thenReturn(pendingIntent);
        when(builder.addRemoteInput(remoteInput)).thenReturn(builder);

        getSubject().build(action);

        verify(notificationBuilder).addAction(nativeAction);
    }

    @Test
    public void factory_build_addsRemoteInputToAction() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.KITKAT_WATCH);

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

        getSubject().build(action);

        verify(builder).addRemoteInput(remoteInput);
        verify(remoteInputBuilder).setLabel("Placeholder");
        verify(notificationBuilder).addAction(nativeAction);
    }

    @Test
    public void factory_buildDismissAction_buildsNativeActionUsingBuildActionMethod() {
        when(intentFactory.createDeletePendingIntent()).thenReturn(pendingIntent);
        getSubject().buildDismissAction();
        verify(notificationBuilder).setDeleteIntent(pendingIntent);
    }
}