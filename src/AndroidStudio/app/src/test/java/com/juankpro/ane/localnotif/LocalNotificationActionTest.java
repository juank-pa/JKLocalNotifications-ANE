package com.juankpro.ane.localnotif;

import com.juankpro.ane.localnotif.category.LocalNotificationAction;

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

import static junit.framework.Assert.assertSame;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static junit.framework.Assert.assertEquals;

/**
 * Created by juank on 11/22/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({LocalNotificationAction.class})
public class LocalNotificationActionTest {
    @Mock
    private JSONObject jsonObject;
    private LocalNotificationAction subject;

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(true);
        when(jsonObject.optString("identifier", "")).thenReturn("MyId");
        when(jsonObject.optString("title", "")).thenReturn("Title");

        try {
            PowerMockito.whenNew(JSONObject.class).withNoArguments().thenReturn(jsonObject);
        } catch (Throwable e) { e.printStackTrace(); }
    }

    private LocalNotificationAction getSubject() {
        return getSubject(null, null);
    }

    private LocalNotificationAction getSubject(String identifier, String title) {
        if (subject == null) {
            subject = new LocalNotificationAction();
            if (identifier != null) subject.identifier = identifier;
            if (title != null) subject.title = title;
        }
        return subject;
    }

    @Test
    public void action_deserialize_deserializesFromJsonObject() {
        assertEquals("", getSubject().identifier);
        assertEquals("", getSubject().title);

        getSubject().deserialize(jsonObject);
        assertEquals("Title", getSubject().title);
        assertEquals("MyId", getSubject().identifier);
    }


    @Test
    public void action_deserialize_doesNothingIfJsonObjectIsNull() {
        getSubject().deserialize(null);
        assertEquals("", getSubject().title);
        assertEquals("", getSubject().identifier);
    }


    @Test
    public void action_serialize_serializesAction() {
        try {
            assertSame(jsonObject, getSubject("MyId", "MyTitle").serialize());
            verify(jsonObject).putOpt("identifier", "MyId");
            verify(jsonObject).putOpt("title", "MyTitle");
        } catch (Throwable e) { e.printStackTrace(); }
    }

    @Test
    public void action_serialize_stopsSerializingIfAnExceptionIsThrown() {
        try {
            when(jsonObject.putOpt("identifier", "MyId")).thenThrow(JSONException.class);

            assertSame(jsonObject, getSubject("MyId", "MyTitle").serialize());
            verify(jsonObject).putOpt("identifier", "MyId");
            verify(jsonObject, never()).putOpt(eq("title"), anyString());
        } catch (Throwable e) { e.printStackTrace(); }
    }
}
