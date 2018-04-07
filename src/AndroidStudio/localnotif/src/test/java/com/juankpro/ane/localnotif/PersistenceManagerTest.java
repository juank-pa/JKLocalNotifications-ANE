package com.juankpro.ane.localnotif;

import android.content.Context;
import android.content.SharedPreferences;

import com.juankpro.ane.localnotif.category.LocalNotificationCategory;
import com.juankpro.ane.localnotif.util.PersistenceManager;

import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import static org.junit.Assert.*;


/**
 * Created by juank on 11/24/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({PersistenceManager.class})
public class PersistenceManagerTest {
    @Mock
    private Context context;
    @Mock
    private SharedPreferences categoryPrefs;
    @Mock
    private SharedPreferences notificationPrefs;
    @Mock
    private SharedPreferences.Editor categoryEditor;
    @Mock
    private SharedPreferences.Editor notificationEditor;
    @Mock
    private JSONObject jsonOjbect;
    private PersistenceManager subject;

    private PersistenceManager getSubject() {
        if (subject == null) {
            subject = new PersistenceManager(context);
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);

        when(context.getSharedPreferences(Constants.CATEGORY_CONFIG, Context.MODE_PRIVATE)).thenReturn(categoryPrefs);
        when(context.getSharedPreferences(Constants.NOTIFICATION_CONFIG, Context.MODE_PRIVATE)).thenReturn(notificationPrefs);

        when(categoryPrefs.edit()).thenReturn(categoryEditor);
        when(notificationPrefs.edit()).thenReturn(notificationEditor);
    }

    @Test
    public void manager_writeNotification_writesGivenNotification() {
        LocalNotification notification = spy(new LocalNotification());
        notification.code = "MyCode";
        when(notification.serialize()).thenReturn(jsonOjbect);
        when(jsonOjbect.toString()).thenReturn("Serialized JSON");

        getSubject().writeNotification(notification);

        verify(notificationEditor).putString("MyCode", "Serialized JSON");
        verify(notificationEditor).commit();
    }

    private void setupReadObject(SharedPreferences preferences, String attribute, boolean throwsException) {
        when(preferences.getString("MyCode", null)).thenReturn("Serialized JSON");
        when(jsonOjbect.optString(attribute, "")).thenReturn("MyRealCode");

        try {
            if (throwsException) {
                PowerMockito.whenNew(JSONObject.class)
                        .withArguments("Serialized JSON").thenThrow(JSONException.class);
            }
            else {
                PowerMockito.whenNew(JSONObject.class).withArguments("Serialized JSON").thenReturn(jsonOjbect);
            }
        } catch (Throwable e) { e.printStackTrace(); }
    }

    private void setupReadObject(SharedPreferences preferences, String attribute) {
        setupReadObject(preferences, attribute, false);
    }

    private void setupReadObjectThrowingException(SharedPreferences preferences, String attribute) {
        setupReadObject(preferences, attribute, true);
    }

    @Test
    public void manager_readNotification_readANotification() {
        setupReadObject(notificationPrefs, "code");
        LocalNotification notification = getSubject().readNotification("MyCode");
        assertEquals("MyRealCode", notification.code);
    }

    @Test
    public void manager_readNotification_returnsNull_whenJsonInvalid() {
        setupReadObjectThrowingException(notificationPrefs, "code");
        LocalNotification notification = getSubject().readNotification("MyCode");
        assertNull(notification);
    }


    @Test
    public void manager_readNotification_returnsNull_whenEntryNotfound() {
        setupReadObject(notificationPrefs, "code");
        when(notificationPrefs.getString("MyCode", null)).thenReturn(null);

        LocalNotification category = getSubject().readNotification("MyCode");
        assertNull(category);
    }

    @Test
    public void manager_removeNotification_removesTheNotification() {
        getSubject().removeNotification("MyCode");

        verify(notificationEditor).remove("MyCode");
        verify(notificationEditor).commit();
    }

    @Test
    public void manager_clearNotifications_removesAllNotifications() {
        getSubject().clearNotifications();

        verify(notificationEditor).clear();
        verify(notificationEditor).commit();
    }

    @SuppressWarnings("unchecked")
    @Test
    public void manager_readNotificationKeys_returnsNotificationKeys() {
        Map<String, String> testMap = new HashMap<>();
        testMap.put("Code1", "JSON 1");
        testMap.put("Code2", "JSON 2");

        when(notificationPrefs.getAll()).thenReturn((Map)testMap);

        Set<String> keys = new HashSet<>();
        keys.add("Code1");
        keys.add("Code2");

        assertEquals(keys, getSubject().readNotificationKeys());
    }

    @Test
    public void manager_writeCategories_writesCategories() {
        LocalNotificationCategory category1 = spy(new LocalNotificationCategory());
        category1.identifier = "MyCode1";
        when(category1.serialize()).thenReturn(jsonOjbect);
        when(jsonOjbect.toString()).thenReturn("Serialized JSON 1");

        JSONObject jsonOjbect2 = mock(JSONObject.class);
        LocalNotificationCategory category2 = spy(new LocalNotificationCategory());
        category2.identifier = "MyCode2";
        when(jsonOjbect2.toString()).thenReturn("Serialized JSON 2");
        when(category2.serialize()).thenReturn(jsonOjbect2);

        getSubject().writeCategories(new LocalNotificationCategory[]{category1, category2});

        verify(categoryEditor).putString("MyCode1", "Serialized JSON 1");
        verify(categoryEditor).putString("MyCode2", "Serialized JSON 2");
        verify(categoryEditor).commit();
    }

    @Test
    public void manager_readCategory_readACategory() {
        setupReadObject(categoryPrefs, "identifier");
        LocalNotificationCategory category = getSubject().readCategory("MyCode");
        assertEquals("MyRealCode", category.identifier);
    }

    @Test
    public void manager_readCategory_returnsNull_whenJsonInvalid() {
        setupReadObjectThrowingException(categoryPrefs, "identifier");
        LocalNotificationCategory category = getSubject().readCategory("MyCode");
        assertNull(category);
    }

    @Test
    public void manager_readCategory_returnsNull_whenEntryNotfound() {
        setupReadObject(categoryPrefs, "identifier");
        when(categoryPrefs.getString("MyCode", null)).thenReturn(null);

        LocalNotificationCategory category = getSubject().readCategory("MyCode");
        assertNull(category);
    }
}
