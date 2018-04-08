package com.juankpro.ane.localnotif;

import android.app.NotificationManager;
import android.os.Build;

import com.juankpro.ane.localnotif.category.LocalNotificationAction;
import com.juankpro.ane.localnotif.category.LocalNotificationCategory;
import com.juankpro.ane.localnotif.serialization.ArrayDeserializer;
import com.juankpro.ane.localnotif.serialization.ArraySerializer;

import org.json.JSONArray;
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
import org.powermock.reflect.Whitebox;

import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertFalse;
import static junit.framework.Assert.assertNull;
import static junit.framework.Assert.assertSame;
import static junit.framework.Assert.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Created by juank on 11/22/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({LocalNotificationCategory.class, Build.class})
public class LocalNotificationCategoryTest {
    @Mock
    private JSONObject jsonObject;
    @Mock
    private JSONArray jsonArray;
    @Mock
    private ArrayDeserializer<LocalNotificationAction> arrayDeserializer;
    @Mock
    private ArraySerializer arraySerializer;
    private LocalNotificationAction[] actions;
    private LocalNotificationCategory subject;

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(true);
        when(jsonObject.optString("identifier", "")).thenReturn("MyId");
        when(jsonObject.optString("name", "")).thenReturn("My Name");

        actions = new LocalNotificationAction[]{new LocalNotificationAction()};

        try {
            PowerMockito.whenNew(ArrayDeserializer.class).withArguments(LocalNotificationAction.class)
                    .thenReturn(arrayDeserializer);
            PowerMockito.whenNew(ArraySerializer.class).withNoArguments().thenReturn(arraySerializer);
            PowerMockito.whenNew(JSONObject.class).withNoArguments().thenReturn(jsonObject);
        } catch (Throwable e) { e.printStackTrace(); }
    }

    private LocalNotificationCategory getSubject() {
        return getSubject(null, null);
    }

    private LocalNotificationCategory getSubject(String identifier, LocalNotificationAction[] actions) {
        return getSubject(identifier, null, actions);
    }

    private LocalNotificationCategory getSubject(String identifier, String name, LocalNotificationAction[] actions) {
        if (subject == null) {
            subject = new LocalNotificationCategory();
            if (identifier != null) subject.identifier = identifier;
            if (name != null) subject.name = name;
            if (actions != null) subject.actions = actions;
        }
        return subject;
    }

    @Test
    public void action_defaultImportance_zeroPreviousToOreo() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.O - 1);
        assertEquals(0, getSubject().importance);
    }

    @Test
    public void action_defaultImportance_zeroForOreoAndLater() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.O);
        assertEquals(NotificationManager.IMPORTANCE_DEFAULT, getSubject().importance);
    }

    @Test
    public void action_deserialize_deserializesFromJsonObject() {
        try {
            when(jsonObject.getJSONArray("actions")).thenReturn(jsonArray);
            when(arrayDeserializer.deserialize(jsonArray)).thenReturn(actions);
        } catch (Throwable e) { e.printStackTrace(); }

        assertEquals("", getSubject().identifier);
        assertNull(getSubject().name);
        assertNull(getSubject().actions);

        getSubject().deserialize(jsonObject);
        assertEquals("MyId", getSubject().identifier);
        assertEquals("My Name", getSubject().name);
        assertSame(actions, getSubject().actions);
    }

    @Test
    public void action_deserialize_deserializesUseCustomDismissAction() {
        try {
            when(jsonObject.optBoolean("useCustomDismissAction")).thenReturn(true);
        } catch (Throwable e) { e.printStackTrace(); }

        assertFalse(getSubject().useCustomDismissAction);
        getSubject().deserialize(jsonObject);
        assertTrue(getSubject().useCustomDismissAction);
    }

    @Test
    public void action_deserialize_doesNothingIfJsonObjectIsNull() {
        getSubject().deserialize(null);
        assertEquals("", getSubject().identifier);
        assertNull(getSubject().actions);
    }

    @Test
    public void action_deserialize_stopsDeserializingIfAnExceptionIsThrown() {
        getSubject().deserialize(jsonObject);
        assertEquals("MyId", getSubject().identifier);
        assertNull(getSubject().actions);
    }

    @Test
    public void action_serialize_serializesCategory() throws JSONException {
        when(arraySerializer.serialize(actions)).thenReturn(jsonArray);

        assertSame(jsonObject, getSubject("MyId", "My Name", actions).serialize());
        verify(jsonObject).putOpt("identifier", "MyId");
        verify(jsonObject).putOpt("name", "My Name");
        verify(jsonObject).putOpt("actions", jsonArray);
    }

    @Test
    public void action_serialize_stopsSerializingIfAnExceptionIsThrown() throws JSONException {
        when(jsonObject.putOpt("identifier", "MyId")).thenThrow(JSONException.class);

        assertSame(jsonObject, getSubject("MyId", actions).serialize());
        verify(jsonObject).putOpt("identifier", "MyId");
        verify(jsonObject, never()).putOpt(eq("actions"), any(LocalNotificationAction[].class));
    }
}
