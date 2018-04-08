package com.juankpro.ane.localnotif;

import android.os.Build;

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
import org.powermock.reflect.Whitebox;

import static junit.framework.Assert.assertFalse;
import static junit.framework.Assert.assertSame;
import static junit.framework.Assert.assertTrue;
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
@PrepareForTest({LocalNotificationAction.class,Build.VERSION.class})
public class LocalNotificationActionTest {
    @Mock
    private JSONObject jsonObject;
    private LocalNotificationAction subject;

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(true);
        when(jsonObject.optString("identifier", "")).thenReturn("MyId");
        when(jsonObject.optString("title", "")).thenReturn("Title");
        when(jsonObject.optString("textInputPlaceholder")).thenReturn("Placeholder");

        try {
            PowerMockito.whenNew(JSONObject.class).withNoArguments().thenReturn(jsonObject);
        } catch (Throwable e) { e.printStackTrace(); }
    }

    private LocalNotificationAction getSubject() {
        return getSubject(null, null, false);
    }

    @SuppressWarnings("SameParameterValue")
    private LocalNotificationAction getSubject(String identifier, String title) {
        return getSubject(identifier, title, false);
    }

    private LocalNotificationAction getSubject(String identifier, String title, boolean isBackground) {
        if (subject == null) {
            subject = new LocalNotificationAction();
            if (identifier != null) subject.identifier = identifier;
            if (title != null) subject.title = title;
            subject.isBackground = isBackground;
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
        assertEquals("Placeholder", getSubject().textInputPlaceholder);
    }

    @Test
    public void action_deserialize_deserializesIsBackgroundFromJsonObject() {
        getSubject().deserialize(jsonObject);
        assertFalse(getSubject().isBackground);

        when(jsonObject.optBoolean("isBackground", false)).thenReturn(true);
        getSubject().deserialize(jsonObject);
        assertTrue(getSubject().isBackground);
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
        } catch (JSONException e) { e.printStackTrace(); }
    }

    @Test
    public void action_serialize_serializesTextInputPlaceHolder() throws JSONException {
        getSubject("MyId", "MyTitle").textInputPlaceholder = "Placeholder";

        assertSame(jsonObject, getSubject().serialize());
        verify(jsonObject).putOpt("identifier", "MyId");
        verify(jsonObject).putOpt("title", "MyTitle");
        verify(jsonObject).putOpt("textInputPlaceholder", "Placeholder");
    }

    @Test
    public void action_serialize_serializesIsBackground() throws JSONException {
        assertSame(jsonObject, getSubject("MyId", "MyTitle", true).serialize());
        verify(jsonObject).putOpt("isBackground", true);
    }

    @Test
    public void action_serialize_serializesIsNotBackground() throws JSONException {
        assertSame(jsonObject, getSubject("MyId", "MyTitle", false).serialize());
        verify(jsonObject).putOpt("isBackground", false);
    }

    @Test
    public void action_serialize_stopsSerializingIfAnExceptionIsThrown() throws JSONException {
        when(jsonObject.putOpt("identifier", "MyId")).thenThrow(JSONException.class);

        assertSame(jsonObject, getSubject("MyId", "MyTitle").serialize());
        verify(jsonObject).putOpt("identifier", "MyId");
        verify(jsonObject, never()).putOpt(eq("title"), anyString());
    }

    @Test
    public void action_isTextInput_returnsTrueIfPlaceholderIsPresent() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.N);
        getSubject().textInputPlaceholder = "Placeholder";
        assertTrue(getSubject().isTextInput());
    }

    @Test
    public void action_isTextInput_returnsFalseIfPlaceholderIsNull() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.N);
        getSubject().textInputPlaceholder = null;
        assertFalse(getSubject().isTextInput());
    }

    @Test
    public void action_isTextInput_returnsFalseIfPlaceholderIsEmpty() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.N);
        getSubject().textInputPlaceholder = "";
        assertFalse(getSubject().isTextInput());
    }

    @Test
    public void action_isTextInput_returnsFalseForVersionsLessThanNougat() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.N - 1);
        getSubject().textInputPlaceholder = "Placeholder";
        assertFalse(getSubject().isTextInput());
    }
}
