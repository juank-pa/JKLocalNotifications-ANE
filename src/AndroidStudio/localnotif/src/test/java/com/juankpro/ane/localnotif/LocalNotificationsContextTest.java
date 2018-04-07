package com.juankpro.ane.localnotif;

import android.app.Activity;
import android.content.Context;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.juankpro.ane.localnotif.category.LocalNotificationCategory;
import com.juankpro.ane.localnotif.category.LocalNotificationCategoryManager;
import com.juankpro.ane.localnotif.decoder.LocalNotificationCategoryDecoder;
import com.juankpro.ane.localnotif.decoder.LocalNotificationDecoder;
import com.juankpro.ane.localnotif.decoder.LocalNotificationSettingsDecoder;
import com.juankpro.ane.localnotif.fre.ExtensionUtils;
import com.juankpro.ane.localnotif.util.PersistenceManager;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.junit.Assert.assertSame;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Created by juank on 11/21/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({
        ExtensionUtils.class,
        LocalNotificationsContext.class,
        LocalNotificationCache.class,
        FREObject.class,
        LocalNotificationSettingsDecoder.class
})
public class LocalNotificationsContextTest {
    @Mock
    private FREContext freContext;
    @Mock
    private FREObject freObject;
    @Mock
    private LocalNotificationManager manager;
    @Mock
    private PersistenceManager persistenceManager;
    @Mock
    private LocalNotificationCategoryManager categoryManager;
    @Mock
    private Context context;
    @Mock
    private LocalNotificationCache cache;
    @Mock
    private FREObject arg1;
    @Mock
    private FREObject arg2;
    @Mock
    private LocalNotificationDecoder decoder;
    @Mock
    private Activity activity;
    private FREObject[] freArgs;
    private LocalNotificationsContext subject;

    private LocalNotificationsContext getSubject() {
        if (subject == null) {
            subject = spy(new LocalNotificationsContext());
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        freArgs = new FREObject[]{arg1, arg2};
        doReturn(activity).when(getSubject()).getActivity();
        doReturn(context).when(activity).getApplicationContext();
        when(subject.getActivity()).thenReturn(activity);
        try {
            PowerMockito.whenNew(LocalNotificationManager.class).withArguments(context).thenReturn(manager);
            PowerMockito.whenNew(PersistenceManager.class).withArguments(context).thenReturn(persistenceManager);
            PowerMockito.whenNew(LocalNotificationCategoryManager.class).withArguments(context).thenReturn(categoryManager);
        } catch (Throwable e) { e.printStackTrace(); }
        PowerMockito.doNothing().when(getSubject()).dispatchStatusEventAsync(anyString(), anyString());
    }

    @Test
    public void context_dispatchNotificationSelectedEvent_clearsLocalNotificationCache() {
        PowerMockito.mockStatic(LocalNotificationCache.class);
        when(LocalNotificationCache.getInstance()).thenReturn(cache);

        getSubject().dispatchNotificationSelectedEvent();
        verify(cache).reset();
    }

    @Test
    public void context_dispatchNotificationSelectedEvent_dispatchesEvent() {
        getSubject().dispatchNotificationSelectedEvent();
        verify(getSubject()).dispatchStatusEventAsync("notificationSelected", "status");
    }

    private FREObject callFunction(String name) {
        return getSubject().getFunctions().get(name).call(freContext, freArgs);
    }

    @Test
    public void context_functions_getSelectedSettings() {
        PowerMockito.mockStatic(FREObject.class);
        try {
            when(FREObject.newObject(7)).thenReturn(freObject);
        } catch (Throwable e) { e.printStackTrace(); }
        assertSame(freObject, callFunction("getSelectedSettings"));
    }

    @Test
    public void context_functions_getSelectedNotificationData() {
        byte[] data = {};
        PowerMockito.mockStatic(LocalNotificationCache.class);
        PowerMockito.mockStatic(ExtensionUtils.class);
        when(LocalNotificationCache.getInstance()).thenReturn(cache);
        when(cache.getNotificationData()).thenReturn(data);
        when(ExtensionUtils.getFreObject(data)).thenReturn(freObject);

        assertSame(freObject, callFunction("getSelectedNotificationData"));
    }

    @Test
    public void context_functions_getSelectedNotificationCode() {
        PowerMockito.mockStatic(LocalNotificationCache.class);
        PowerMockito.mockStatic(FREObject.class);
        when(LocalNotificationCache.getInstance()).thenReturn(cache);
        when(cache.getNotificationCode()).thenReturn("Code");

        try { when(FREObject.newObject("Code")).thenReturn(freObject); }
        catch (Throwable e) {  e.printStackTrace(); }

        assertSame(freObject, callFunction("getSelectedNotificationCode"));
    }

    @Test
    public void context_functions_getSelectedActionId() {
        PowerMockito.mockStatic(LocalNotificationCache.class);
        PowerMockito.mockStatic(FREObject.class);
        when(LocalNotificationCache.getInstance()).thenReturn(cache);
        when(cache.getActionId()).thenReturn("ActionId");

        try { when(FREObject.newObject("ActionId")).thenReturn(freObject); }
        catch (Throwable e) {  e.printStackTrace(); }

        assertSame(freObject, callFunction("getSelectedNotificationAction"));
    }

    @Test
    public void context_functions_getSelectedUserResponse() {
        PowerMockito.mockStatic(LocalNotificationCache.class);
        PowerMockito.mockStatic(FREObject.class);
        when(LocalNotificationCache.getInstance()).thenReturn(cache);
        when(cache.getUserResponse()).thenReturn("User Response");

        try { when(FREObject.newObject("User Response")).thenReturn(freObject); }
        catch (Throwable e) {  e.printStackTrace(); }

        assertSame(freObject, callFunction("getSelectedNotificationUserResponse"));
    }

    @Test
    public void context_functions_checkForNotificationAction_whenCacheWasUpdated() {
        byte data[] = {};
        LocalNotificationCache.getInstance().reset();
        LocalNotificationCache.getInstance().setData("MyCode", data, "actionId", "User Response");

        callFunction("checkForNotificationAction");
        verify(getSubject()).dispatchStatusEventAsync("notificationSelected", "status");
    }

    @Test
    public void context_functions_checkForNotificationAction_whenCacheWasNotUpdated() {
        LocalNotificationCache.getInstance().reset();

        callFunction("checkForNotificationAction");
        verify(getSubject(), never()).dispatchStatusEventAsync("notificationSelected", "status");
    }

    @Test
    public void context_functions_checkForNotificationAction_dispatchesOnlyOnce() {
        byte data[] = {};
        LocalNotificationCache.getInstance().reset();
        LocalNotificationCache.getInstance().setData("MyCode", data, "actionId", "User Response");

        callFunction("checkForNotificationAction");
        callFunction("checkForNotificationAction");

        verify(getSubject(), times(1)).dispatchStatusEventAsync("notificationSelected", "status");
    }

    @Test
    public void context_functions_notify() {
        LocalNotification notification = new LocalNotification("test");
        try {
            PowerMockito.whenNew(LocalNotificationDecoder.class)
                    .withArguments(freContext, arg1)
                    .thenReturn(decoder);
        } catch (Throwable e) { e.printStackTrace(); }
        when(decoder.decodeObject(arg2)).thenReturn(notification);

        callFunction("notify");

        verify(manager).notify(notification);
        verify(persistenceManager).writeNotification(notification);
    }

    @Test
    public void context_functions_cancel() {
        try { when(arg1.getAsString()).thenReturn("MyID"); }
        catch (Throwable e) { e.printStackTrace(); }
        callFunction("cancel");
        verify(manager).cancel("MyID");
        verify(persistenceManager).removeNotification("MyID");
    }

    @Test
    public void context_functions_cancelAll() {
        callFunction("cancelAll");
        verify(manager).cancelAll();
        verify(persistenceManager).clearNotifications();
    }

    @Test
    public void context_functions_registerSettings() {
        LocalNotificationSettingsDecoder decoder = mock(LocalNotificationSettingsDecoder.class);

        try {
            PowerMockito.whenNew(LocalNotificationSettingsDecoder.class)
                    .withArguments(freContext)
                    .thenReturn(decoder);
        } catch (Throwable e) {
            e.printStackTrace();
        }

        LocalNotificationSettings settings = new LocalNotificationSettings();
        settings.categories = new LocalNotificationCategory[]{};
        when(decoder.decodeObject(arg1)).thenReturn(settings);

        callFunction("registerSettings");

        verify(categoryManager).registerCategories(settings.categories);
        verify(getSubject()).dispatchStatusEventAsync("settingsSubscribed", "status");
    }

    @Test
    public void context_functions_registerDefaultCategory() {
        LocalNotificationCategoryDecoder decoder = mock(LocalNotificationCategoryDecoder.class);

        try {
            PowerMockito.whenNew(LocalNotificationCategoryDecoder.class)
                    .withArguments(freContext)
                    .thenReturn(decoder);
        } catch (Throwable e) {
            e.printStackTrace();
        }

        LocalNotificationCategory category = new LocalNotificationCategory();
        LocalNotificationCategory[] categories = new LocalNotificationCategory[]{ category };
        when(decoder.decodeObject(arg1)).thenReturn(category);

        callFunction("registerDefaultCategory");

        verify(categoryManager).registerCategories(categories);
    }
}
