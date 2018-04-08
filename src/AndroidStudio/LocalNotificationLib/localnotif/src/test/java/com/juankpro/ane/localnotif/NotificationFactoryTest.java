package com.juankpro.ane.localnotif;

import android.app.Notification;
import android.app.PendingIntent;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;

import com.juankpro.ane.localnotif.category.LocalNotificationAction;
import com.juankpro.ane.localnotif.category.LocalNotificationCategory;
import com.juankpro.ane.localnotif.category.LocalNotificationCategoryManager;
import com.juankpro.ane.localnotif.factory.NotificationActionBuilder;
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
import org.powermock.reflect.Whitebox;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import static org.junit.Assert.*;
import static org.mockito.internal.verification.VerificationModeFactory.times;
import static org.powermock.api.mockito.PowerMockito.verifyNew;

/**
 * Created by Juank on 11/9/17.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({NotificationFactory.class, Uri.class, Build.VERSION.class, NotificationSoundProvider.class})
public class NotificationFactoryTest {
    @Mock
    private Context context;
    @Mock
    private Bundle bundle;
    @Mock
    private Notification.Builder builder;
    @Mock
    private PendingIntent pendingIntent;
    @Mock
    private NotificationPendingIntentFactory intentFactory;
    @Mock
    private Notification.BigTextStyle textStyle;
    @Mock
    private LocalNotificationCategoryManager categoryManager;
    @Mock
    private NotificationActionBuilder actionBuilder;
    @Mock
    private Uri uri;
    private LocalNotificationCategory category = new LocalNotificationCategory();
    private Notification notification = new Notification();
    private NotificationFactory subject;
    private ApplicationInfo appInfo;

    private NotificationFactory getSubject() {
        if (subject == null) {
            subject = new NotificationFactory(context, bundle);
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);

        try {
            PowerMockito.whenNew(Notification.Builder.class).withArguments(context).thenReturn(builder);
            PowerMockito.whenNew(LocalNotificationCategoryManager.class).withArguments(context).thenReturn(categoryManager);
            PowerMockito.whenNew(Notification.BigTextStyle.class).withNoArguments().thenReturn(textStyle);
        } catch(Exception e) { e.printStackTrace(); }

        when(bundle.getInt(Constants.NUMBER_ANNOTATION)).thenReturn(10);
        when(bundle.getInt(Constants.ICON_RESOURCE)).thenReturn(1001);
        when(bundle.getString(Constants.TICKER_TEXT)).thenReturn("Ticker text");
        when(bundle.getString(Constants.TITLE)).thenReturn("Title");
        when(bundle.getString(Constants.BODY)).thenReturn("Body");
        when(bundle.getString(Constants.NOTIFICATION_CODE_KEY)).thenReturn("MyCode");
        when(bundle.getInt(Constants.PRIORITY)).thenReturn(2);

        when(builder.setContentTitle(any(CharSequence.class))).thenReturn(builder);
        when(builder.setContentText(any(CharSequence.class))).thenReturn(builder);
        when(builder.setSmallIcon(anyInt())).thenReturn(builder);
        when(builder.setTicker(any(CharSequence.class))).thenReturn(builder);
        when(builder.setDefaults(anyInt())).thenReturn(builder);
        when(builder.setNumber(anyInt())).thenReturn(builder);
        when(builder.setStyle(any(Notification.Style.class))).thenReturn(builder);
        when(builder.setOngoing(anyBoolean())).thenReturn(builder);
        when(builder.setAutoCancel(anyBoolean())).thenReturn(builder);
        when(builder.setOnlyAlertOnce(anyBoolean())).thenReturn(builder);
        when(builder.setStyle(any(Notification.Style.class))).thenReturn(builder);
        when(builder.setSound((Uri)any())).thenReturn(builder);
        when(builder.setPriority(anyInt())).thenReturn(builder);
        when(builder.build()).thenReturn(notification);

        when(textStyle.bigText(anyString())).thenReturn(textStyle);

        category.identifier = "MyId";

        appInfo = new ApplicationInfo();
        when(context.getApplicationInfo()).thenReturn(appInfo);

        when(intentFactory.createPendingIntent()).thenReturn(pendingIntent);
    }

    @Test
    public void factory_constructor_priorToOreo_initializesNotificationBuilderWithoutChannelId() throws Exception {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.O - 1);
        when(bundle.getString(Constants.CATEGORY)).thenReturn("MyCategory");
        when(categoryManager.readCategory("MyCategory")).thenReturn(category);
        category.name = "My Name";
        appInfo.targetSdkVersion = Build.VERSION_CODES.O;
        getSubject();
        verifyNew(Notification.Builder.class).withArguments(context);
    }

    @Test
    public void factory_constructor_targetingLowerThanOreo_initializesNotificationBuilderWithoutChannelId() throws Exception {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.O);
        when(bundle.getString(Constants.CATEGORY)).thenReturn("MyCategory");
        when(categoryManager.readCategory("MyCategory")).thenReturn(category);
        category.name = "My Name";
        appInfo.targetSdkVersion = Build.VERSION_CODES.O - 1;
        getSubject();

        verifyNew(Notification.Builder.class).withArguments(context);
    }

    @Test
    public void factory_constructor_withoutCategory_initializesNotificationBuilderWithoutChannelId() throws Exception {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.O);
        appInfo.targetSdkVersion = Build.VERSION_CODES.O;
        getSubject();

        verifyNew(Notification.Builder.class).withArguments(context);
    }

    @Test
    public void factory_constructor_inOreoAndHigher_targetingOreo_withCategory_initializesNotificationBuilderWithChannelId() throws Exception {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.O);
        when(bundle.getString(Constants.CATEGORY)).thenReturn("MyCategory");
        when(categoryManager.readCategory("MyCategory")).thenReturn(category);
        category.name = "My Name";
        appInfo.targetSdkVersion = Build.VERSION_CODES.O;
        getSubject();

        verifyNew(Notification.Builder.class).withArguments(context, category.identifier);
    }

    @Test
    public void factory_constructor_withUnnamedCategory_initializesNotificationBuilderWithoutChannelId() throws Exception {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.O);
        when(bundle.getString(Constants.CATEGORY)).thenReturn("MyCategory");
        when(categoryManager.readCategory("MyCategory")).thenReturn(category);
        appInfo.targetSdkVersion = Build.VERSION_CODES.O;
        getSubject();

        verifyNew(Notification.Builder.class).withArguments(context);
    }

    @Test
    public void factory_create_createsANotificationWithTheGivenInformation() {
        Notification notification = getSubject().create(intentFactory);
        verify(builder).setSmallIcon(1001);
        verify(builder).setNumber(10);
        verify(builder).setTicker("Ticker text");
        verify(builder).setContentTitle("Title");
        verify(builder).setContentText("Body");
        verify(builder).setPriority(2);
        assertSame(notification, this.notification);
    }

    @Test
    public void factory_create_createsWithBigTextLayout() {
        try {
            PowerMockito.whenNew(Notification.BigTextStyle.class)
                    .withNoArguments().thenReturn(textStyle);
        } catch(Exception e) { e.printStackTrace(); }

        getSubject().create(intentFactory);
        verify(textStyle).bigText("Body");
        verify(builder).setStyle(textStyle);
    }

    @Test
    public void factory_create_createsWithCustomSound() {
        NotificationSoundProvider.CONTENT_URI = "content://simple.uri";
        when(bundle.getBoolean(Constants.PLAY_SOUND)).thenReturn(true);
        when(bundle.getString(Constants.SOUND_NAME)).thenReturn("sound.mp3");

        PowerMockito.mockStatic(Uri.class);
        when(Uri.parse("content://simple.uri/sound.mp3")).thenReturn(uri);

        getSubject().create(intentFactory);
        verify(builder).setSound(uri);
    }

    @Test
    public void factory_create_createsWithDefaultSound() {
        getSubject().create(intentFactory);
        verify(builder).setDefaults(Notification.DEFAULT_LIGHTS);

        when(bundle.getBoolean(Constants.PLAY_SOUND)).thenReturn(true);

        getSubject().create(intentFactory);
        verify(builder).setDefaults(Notification.DEFAULT_SOUND | Notification.DEFAULT_LIGHTS);
        verify(builder, times(2)).setSound(null);
    }

    @Test
    public void factory_create_createsWithDefaultVibration() {
        when(bundle.getBoolean(Constants.VIBRATE)).thenReturn(true);

        getSubject().create(intentFactory);
        verify(builder).setDefaults(Notification.DEFAULT_VIBRATE | Notification.DEFAULT_LIGHTS);
    }

    @Test
    public void factory_create_createsAsOngoing() {
        getSubject().create(intentFactory);
        verify(builder).setOngoing(false);

        when(bundle.getBoolean(Constants.ON_GOING)).thenReturn(true);

        getSubject().create(intentFactory);
        verify(builder).setOngoing(true);
    }

    @Test
    public void factory_create_createsAsAutoCancel() {
        getSubject().create(intentFactory);
        verify(builder).setAutoCancel(false);

        when(bundle.getBoolean(Constants.CANCEL_ON_SELECT)).thenReturn(true);

        getSubject().create(intentFactory);
        verify(builder).setAutoCancel(true);
    }

    @Test
    public void factory_create_createsToAlertOnlyOnceWithFirstTimePolicy() {
        getSubject().create(intentFactory);
        verify(builder).setOnlyAlertOnce(false);

        when(bundle.getString(Constants.ALERT_POLICY)).thenReturn("firstNotification");

        getSubject().create(intentFactory);
        verify(builder).setOnlyAlertOnce(true);
    }

    @Test
    public void factory_create_createsToAlertOnlyOnceWithSomethingElse() {
        when(bundle.getString(Constants.ALERT_POLICY)).thenReturn("somethingElse");

        getSubject().create(intentFactory);
        verify(builder).setOnlyAlertOnce(false);
    }

    @Test
    public void factory_create_createsWithAction() {
        getSubject().create(intentFactory);
        verify(builder, never()).setContentIntent(pendingIntent);

        when(bundle.getBoolean(Constants.HAS_ACTION)).thenReturn(true);

        getSubject().create(intentFactory);
        verify(builder).setContentIntent(pendingIntent);
    }

    private void prepareCategory() {
        try {
            PowerMockito.whenNew(NotificationActionBuilder.class)
                    .withArguments(intentFactory, builder)
                    .thenReturn(actionBuilder);
        }
        catch (Throwable e) { e.printStackTrace(); }
        category.actions = new LocalNotificationAction[0];

        when(bundle.getString(Constants.CATEGORY)).thenReturn("MyCategory");
        when(categoryManager.readCategory("MyCategory")).thenReturn(category);
    }

    @Test
    public void factory_create_withActionButtons() {
        prepareCategory();

        LocalNotificationAction action = new LocalNotificationAction();
        action.icon = 200;
        action.title = "Remove";
        action.identifier = "removeAction";

        category.actions = new LocalNotificationAction[]{action};

        getSubject().create(intentFactory);

        verify(actionBuilder).build(action);
    }

    @Test
    public void factory_create_withDismissAction() {
        prepareCategory();

        getSubject().create(intentFactory);
        verify(actionBuilder, never()).buildDismissAction();

        category.useCustomDismissAction = true;

        getSubject().create(intentFactory);
        verify(actionBuilder).buildDismissAction();
    }
}