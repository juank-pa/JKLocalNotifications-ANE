package com.juankpro.ane.localnotif;

import android.os.Build;

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

import java.util.Date;

import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertNull;
import static junit.framework.Assert.assertSame;
import static junit.framework.Assert.assertTrue;
import static junit.framework.TestCase.assertFalse;
import static org.junit.Assert.assertArrayEquals;
import static org.mockito.ArgumentMatchers.anyBoolean;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Created by juank on 11/26/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({LocalNotification.class, Build.VERSION.class})
public class LocalNotificationTest {
    @Mock
    private JSONObject jsonObject;
    @Mock
    private JSONArray jsonArray;
    private LocalNotification subject;

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(true);
        try {
            PowerMockito.whenNew(JSONObject.class).withNoArguments().thenReturn(jsonObject);
        } catch (Throwable e) { e.printStackTrace(); }
    }

    private LocalNotification getSubject() {
        return getSubject(null);
    }

    private LocalNotification getSubject(String identifier) {
        if (subject == null) {
            subject = new LocalNotification();
            subject.hasAction = false;
            if (identifier != null) {
                subject.code = identifier;
                subject.tickerText = "Ticker2";
                subject.title = "Title2";
                subject.body = "Body2";
                subject.iconResourceId = 32;
                subject.numberAnnotation = 12;
                subject.alertPolicy = "policy2";
                subject.soundName = "sound2.mp3";
                subject.activityClassName = "ClassName2";
                subject.priority = 1;
                subject.fireDate = new Date(50000);
                subject.repeatInterval = 231;
                subject.category = "Category2";
            }
        }
        return subject;
    }

    @Test
    public void notification_deserialize_deserializesFromJsonObject() {
        when(jsonObject.optString("code", "")).thenReturn("MyCode");
        when(jsonObject.optString("tickerText", "")).thenReturn("Ticker");
        when(jsonObject.optString("title", "")).thenReturn("Title");
        when(jsonObject.optString("body", "")).thenReturn("Body");
        when(jsonObject.optInt("iconResourceId", 0)).thenReturn(10);
        when(jsonObject.optInt("numberAnnotation", 0)).thenReturn(5);
        when(jsonObject.optString("alertPolicy", "")).thenReturn("policy");
        when(jsonObject.optString("soundName", "")).thenReturn("sound.mp3");
        when(jsonObject.optString("activityClassName", null)).thenReturn("ClassName");
        when(jsonObject.optInt("priority", 0)).thenReturn(2);
        when(jsonObject.optLong("fireDate", getSubject().fireDate.getTime())).thenReturn((long)100000);
        when(jsonObject.optInt("repeatInterval", 0)).thenReturn(2000);
        when(jsonObject.optString("category", "")).thenReturn("Category");

        assertEquals("", getSubject().code);
        assertEquals("", getSubject().tickerText);
        assertEquals("", getSubject().title);
        assertEquals("", getSubject().body);
        assertEquals(0, getSubject().iconResourceId);
        assertEquals(0, getSubject().numberAnnotation);
        assertEquals("", getSubject().alertPolicy);
        assertEquals("", getSubject().soundName);
        assertNull(getSubject().activityClassName);
        assertEquals(0, getSubject().priority);
        assertEquals(new Date(getSubject().fireDate.getTime()), getSubject().fireDate);
        assertEquals(0, getSubject().repeatInterval);
        assertEquals("", getSubject().category);

        getSubject().deserialize(jsonObject);

        assertEquals("MyCode", getSubject().code);
        assertEquals("Ticker", getSubject().tickerText);
        assertEquals("Title", getSubject().title);
        assertEquals("Body", getSubject().body);
        assertEquals(10, getSubject().iconResourceId);
        assertEquals(5, getSubject().numberAnnotation);
        assertEquals("policy", getSubject().alertPolicy);
        assertEquals("sound.mp3", getSubject().soundName);
        assertEquals("ClassName", getSubject().activityClassName);
        assertEquals(2, getSubject().priority);
        assertEquals(new Date(100000), getSubject().fireDate);
        assertEquals(2000, getSubject().repeatInterval);
        assertEquals("Category", getSubject().category);
    }

    @Test
    public void notification_deserialize_deserializesPlaySoundFromJsonObject() {
        when(jsonObject.optBoolean("playSound", false)).thenReturn(true);
        assertEquals(false, getSubject().playSound);
        getSubject().deserialize(jsonObject);
        assertEquals(true, getSubject().playSound);
    }

    @Test
    public void notification_deserialize_deserializesVibrateFromJsonObject() {
        when(jsonObject.optBoolean("vibrate", false)).thenReturn(true);
        assertEquals(false, getSubject().vibrate);
        getSubject().deserialize(jsonObject);
        assertEquals(true, getSubject().vibrate);
    }

    @Test
    public void notification_deserialize_deserializesCancelOnSelectFromJsonObject() {
        when(jsonObject.optBoolean("cancelOnSelect", false)).thenReturn(true);
        assertEquals(false, getSubject().cancelOnSelect);
        getSubject().deserialize(jsonObject);
        assertEquals(true, getSubject().cancelOnSelect);
    }

    @Test
    public void notification_deserialize_deserializesOngoingFromJsonObject() {
        when(jsonObject.optBoolean("ongoing", false)).thenReturn(true);
        assertEquals(false, getSubject().ongoing);
        getSubject().deserialize(jsonObject);
        assertEquals(true, getSubject().ongoing);
    }

    @Test
    public void notification_deserialize_deserializesHasActionFromJsonObject() {
        when(jsonObject.optBoolean("hasAction", false)).thenReturn(true);
        assertEquals(false, getSubject().hasAction);
        getSubject().deserialize(jsonObject);
        assertEquals(true, getSubject().hasAction);
    }

    @Test
    public void notification_deserialize_deserializesShowInForegroundFromJsonObject() {
        when(jsonObject.optBoolean("showInForeground", false)).thenReturn(true);
        assertEquals(false, getSubject().showInForeground);
        getSubject().deserialize(jsonObject);
        assertEquals(true, getSubject().showInForeground);
    }

    @Test
    public void notification_deserialize_deserializesByteDataFromJsonObject() {
        try {
            when(jsonObject.getJSONArray("actionData")).thenReturn(jsonArray);
            when(jsonArray.length()).thenReturn(2);
            when(jsonArray.getInt(0)).thenReturn(101);
            when(jsonArray.getInt(1)).thenReturn(30);
        } catch (Throwable e) { e.printStackTrace(); }

        getSubject().deserialize(jsonObject);

        assertArrayEquals(new byte[]{101, 30}, getSubject().actionData);
    }

    @Test
    public void notification_deserialize_deserializesIsExactFromJsonObject() {
        when(jsonObject.optBoolean("isExact", false)).thenReturn(true);
        assertEquals(false, getSubject().isExact);
        getSubject().deserialize(jsonObject);
        assertEquals(true, getSubject().isExact);
    }

    @Test
    public void notification_deserialize_deserializesAllowWhileIdleFromJsonObject() {
        when(jsonObject.optBoolean("allowWhileIdle", false)).thenReturn(true);
        assertEquals(false, getSubject().allowWhileIdle);
        getSubject().deserialize(jsonObject);
        assertEquals(true, getSubject().allowWhileIdle);
    }

    @Test
    public void notification_deserialize_doesNothingIfJsonObjectIsNull() {
        getSubject().deserialize(null);
        verify(jsonObject, never()).optString(eq("code"), anyString());
        verify(jsonObject, never()).optString(eq("tickerText"), anyString());
        verify(jsonObject, never()).optString(eq("title"), anyString());
        verify(jsonObject, never()).optString(eq("body"), anyString());
        verify(jsonObject, never()).optBoolean(eq("playSound"), anyBoolean());
        verify(jsonObject, never()).optInt(eq("iconResourceId"), anyInt());
        verify(jsonObject, never()).optInt(eq("numberAnnotation"), anyInt());
        verify(jsonObject, never()).optBoolean(eq("cancelOnSelect"), anyBoolean());
        verify(jsonObject, never()).optBoolean(eq("ongoing"), anyBoolean());
        verify(jsonObject, never()).optString(eq("alertPolicy"), anyString());
        verify(jsonObject, never()).optBoolean(eq("hasAction"), anyBoolean());
        verify(jsonObject, never()).optString(eq("soundName"), anyString());
        verify(jsonObject, never()).optString(eq("activityClassName"), anyString());
        verify(jsonObject, never()).optInt(eq("priority"), anyInt());
        verify(jsonObject, never()).optBoolean(eq("showInForeground"), anyBoolean());
        verify(jsonObject, never()).optLong(eq("fireDate"), anyLong());
        verify(jsonObject, never()).optInt(eq("repeatInterval"), anyInt());
        verify(jsonObject, never()).optString(eq("category"), anyString());
    }

    @Test
    public void notification_deserialize_stopsDeserializingByteArrayIfAnExceptionIsThrown() {
        try {
            when(jsonObject.getJSONArray("actionData")).thenReturn(jsonArray);
            when(jsonArray.length()).thenReturn(2);
            when(jsonArray.getInt(0)).thenReturn(101);
            when(jsonArray.getInt(1)).thenThrow(mock(JSONException.class));
        } catch (Throwable e) { e.printStackTrace(); }

        getSubject().deserialize(jsonObject);
        assertArrayEquals(new byte[]{101, 0}, getSubject().actionData);
        getSubject().actionData = null;

        try {
            when(jsonObject.getJSONArray("actionData")).thenThrow(mock(JSONException.class));
        } catch (Throwable e) { e.printStackTrace(); }

        getSubject().deserialize(jsonObject);

        assertNull(getSubject().actionData);
    }

    @Test
    public void action_serialize_serializesNotification() throws JSONException {
        assertSame(jsonObject, getSubject("MyCode").serialize());
        verify(jsonObject).putOpt("code", "MyCode");
        verify(jsonObject).putOpt("tickerText", "Ticker2");
        verify(jsonObject).putOpt("title", "Title2");
        verify(jsonObject).putOpt("body", "Body2");
        verify(jsonObject).putOpt("iconResourceId", 32);
        verify(jsonObject).putOpt("numberAnnotation", 12);
        verify(jsonObject).putOpt("alertPolicy", "policy2");
        verify(jsonObject).putOpt("soundName", "sound2.mp3");
        verify(jsonObject).putOpt("fireDate", (long)50000);
        verify(jsonObject).putOpt("repeatInterval", 231);
        verify(jsonObject).putOpt("activityClassName", "ClassName2");
        verify(jsonObject).putOpt("priority", 1);
        verify(jsonObject).putOpt("category", "Category2");
    }

    @Test
    public void action_serialize_serializesPlaySound() throws JSONException {
        getSubject().playSound = true;
        assertSame(jsonObject, getSubject().serialize());
        verify(jsonObject).putOpt("playSound", true);
    }

    @Test
    public void action_serialize_serializesVibrate() throws JSONException {
        getSubject().vibrate = true;
        assertSame(jsonObject, getSubject().serialize());
        verify(jsonObject).putOpt("vibrate", true);
    }

    @Test
    public void action_serialize_serializesCancelOnSelect() throws JSONException {
        getSubject().cancelOnSelect = true;
        assertSame(jsonObject, getSubject().serialize());
        verify(jsonObject).putOpt("cancelOnSelect", true);
    }

    @Test
    public void action_serialize_serializesOngoing() throws JSONException {
        getSubject().ongoing = true;
        assertSame(jsonObject, getSubject().serialize());
        verify(jsonObject).putOpt("ongoing", true);
    }

    @Test
    public void action_serialize_serializesHasAction() throws JSONException {
        getSubject().hasAction = true;
        assertSame(jsonObject, getSubject().serialize());
        verify(jsonObject).putOpt("hasAction", true);
    }

    @Test
    public void action_serialize_serializesShowInForeground() throws JSONException {
        getSubject().showInForeground = true;
        assertSame(jsonObject, getSubject().serialize());
        verify(jsonObject).putOpt("showInForeground", true);
    }

    @Test
    public void action_serialize_serializesByteData() throws JSONException {
        getSubject().actionData = new byte[]{102, 127};

        assertSame(jsonObject, getSubject().serialize());

        verify(jsonObject).accumulate("actionData", 102);
        verify(jsonObject).accumulate("actionData", 127);
    }

    @Test
    public void notification_serialize_serializesIsExact() {
        try {
            getSubject().isExact = true;
            assertSame(jsonObject, getSubject().serialize());
            verify(jsonObject).putOpt("isExact", true);
        } catch (JSONException e) { e.printStackTrace(); }
    }
    
    @Test
    public void notification_serialize_serializesAllowWhileIdle() {
        try {
            getSubject().allowWhileIdle = true;
            assertSame(jsonObject, getSubject().serialize());
            verify(jsonObject).putOpt("allowWhileIdle", true);
        } catch (JSONException e) { e.printStackTrace(); }
    }

    @Test
    public void notification_serialize_stopsSerializingDataIfAnExceptionIsThrown() throws JSONException {
        try {
            getSubject().actionData = new byte[]{102, 127};
            when(jsonObject.accumulate("actionData", 102)).thenThrow(mock(JSONException.class));
        } catch (Throwable e) { e.printStackTrace(); }

        assertSame(jsonObject, getSubject().serialize());

        verify(jsonObject).accumulate("actionData", 102);
        verify(jsonObject, never()).accumulate("actionData", 127);
    }

    @Test
    public void notification_getRepeatIntervalMilliseconds_returnsTimeInMilliseconds() {
        LocalNotificationTimeInterval intervalMock = mock(LocalNotificationTimeInterval.class);
        try {
            PowerMockito.whenNew(LocalNotificationTimeInterval.class)
                    .withArguments(10)
                    .thenReturn(intervalMock);
        } catch (Throwable e) { e.printStackTrace(); }
        when(intervalMock.toMilliseconds()).thenReturn(20000L);

        getSubject().repeatInterval = 10;
        assertEquals(getSubject().getRepeatIntervalMilliseconds(), 20000L);
    }

    @Test
    public void notification_repeatsRecurrently_returnsTrueIfHasRepeatInterval_afterKitKat() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.KITKAT);
        getSubject().repeatInterval = 10;
        getSubject().isExact = false;
        assertTrue(getSubject().repeatsRecurrently());
    }

    @Test
    public void notification_repeatsRecurrently_returnsTrueIfHasRepeatIntervalAndIsExact() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.KITKAT - 1);
        getSubject().repeatInterval = 10;
        getSubject().isExact = true;
        assertTrue(getSubject().repeatsRecurrently());
    }

    @Test
    public void notification_repeatsRecurrently_returnsFalseIfDoesNotHaveRepeatInterval() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.KITKAT);
        getSubject().repeatInterval = 0;
        getSubject().isExact = true;
        assertFalse(getSubject().repeatsRecurrently());
    }

    @Test
    public void notification_repeatsRecurrently_returnsFalseIfNonExact_beforeKitKat() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.KITKAT - 1);
        getSubject().repeatInterval = 10;
        getSubject().isExact = false;
        assertFalse(getSubject().repeatsRecurrently());
    }
}
