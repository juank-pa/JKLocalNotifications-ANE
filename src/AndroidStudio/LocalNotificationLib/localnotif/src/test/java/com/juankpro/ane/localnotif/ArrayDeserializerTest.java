package com.juankpro.ane.localnotif;

import com.juankpro.ane.localnotif.serialization.ArrayDeserializer;

import org.json.JSONArray;
import org.json.JSONException;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertTrue;
import static org.mockito.Mockito.when;

/**
 * Created by juank on 11/22/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({ArrayDeserializer.class})
public class ArrayDeserializerTest {
    @Mock
    private JSONArray jsonArray;

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
    }

    private DeserializableTest[] deserialize(JSONArray jsonArray) {
        try {
            return new ArrayDeserializer<>(DeserializableTest.class)
                    .deserialize(jsonArray);
        } catch (Throwable e) { e.printStackTrace(); }
        return null;
    }

    private DeserializableTest[] deserialize() {
        return deserialize(jsonArray);
    }

    @Test
    public void deserializer_deserializesJsonArrayIntoArray() {
        when(jsonArray.length()).thenReturn(1);
        DeserializableTest[] result = deserialize();
        assertEquals(1, result.length);
        assertTrue(result[0].deserialized);
    }

    @Test
    public void deserializer_deserializesEmptyJsonArrayIntoEmptyArray() {
        when(jsonArray.length()).thenReturn(0);
        DeserializableTest[] result = deserialize();
        assertEquals(0, result.length);
    }

    @Test
    public void deserializer_deserializesNullIntoEmptyArray() {
        DeserializableTest[] result = deserialize(null);
        assert(result != null);
        assertEquals(0, result.length);
    }

    @Test
    public void deserializer_deserializesIntoEmptyArrayIfAnExceptionIsThrown() {
        DeserializableTest[] result = null;

        try {
            when(jsonArray.length()).thenReturn(2);
            when(jsonArray.getJSONObject(0)).thenThrow(JSONException.class);
        } catch (Throwable e) { e.printStackTrace(); }

        result = deserialize(null);
        assert (result != null);
        assertEquals(0, result.length);
    }
}

