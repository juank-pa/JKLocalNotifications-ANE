package com.juankpro.ane.localnotif;

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

import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertNull;
import static junit.framework.Assert.assertSame;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Created by juank on 11/22/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({LocalNotificationCategory.class})
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
        if (subject == null) {
            subject = new LocalNotificationCategory();
            if (identifier != null) subject.identifier = identifier;
            if (actions != null) subject.actions = actions;
        }
        return subject;
    }

    @Test
    public void action_deserialize_deserializesFromJsonObject() {
        try {
            when(jsonObject.getJSONArray("actions")).thenReturn(jsonArray);
            when(arrayDeserializer.deserialize(jsonArray)).thenReturn(actions);
        } catch (Throwable e) { e.printStackTrace(); }

        assertEquals("", getSubject().identifier);
        assertNull(getSubject().actions);

        getSubject().deserialize(jsonObject);
        assertEquals("MyId", getSubject().identifier);
        assertSame(actions, getSubject().actions);
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
    public void action_serialize_serializesAction() {
        when(arraySerializer.serialize(actions)).thenReturn(jsonArray);

        assertSame(jsonObject, getSubject("MyId", actions).serialize());
        try {
            verify(jsonObject).putOpt("identifier", "MyId");
            verify(jsonObject).putOpt("actions", jsonArray);
        } catch (JSONException e) { e.printStackTrace(); }
    }

    @Test
    public void action_serialize_stopsSerializingIfAnExceptionIsThrown() {
        try {
            when(jsonObject.putOpt("identifier", "MyId")).thenThrow(JSONException.class);

            assertSame(jsonObject, getSubject("MyId", actions).serialize());
            verify(jsonObject).putOpt("identifier", "MyId");
            verify(jsonObject, never()).putOpt(eq("actions"), any(LocalNotificationAction[].class));
        } catch (JSONException e) { e.printStackTrace(); }
    }
}
