package com.juankpro.ane.localnotif;

import com.juankpro.ane.localnotif.serialization.ArraySerializer;
import com.juankpro.ane.localnotif.serialization.ISerializable;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.junit.Assert.assertSame;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Created by juank on 11/22/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({ArraySerializer.class})
public class ArraySerializerTest {
    @Mock
    private JSONArray jsonArray;
    @Mock
    private JSONObject jsonObject;
    @Mock
    private ISerializable serializable;

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        when(serializable.serialize()).thenReturn(jsonObject);

        try {
            PowerMockito.whenNew(JSONArray.class).withNoArguments().thenReturn(jsonArray);
        } catch (Throwable e) { e.printStackTrace(); }
    }

    @Test
    public void serializer_convertsAnArrayOfSerializablesToJsonArray() {
        JSONArray result = new ArraySerializer().serialize(new ISerializable[]{serializable});
        assertSame(jsonArray, result);
        verify(jsonArray).put(jsonObject);
    }

    @Test
    public void serializer_serializesEmptyArrayIntoEmptyJsonArray() {
        JSONArray result = new ArraySerializer().serialize(new ISerializable[]{});
        assertSame(jsonArray, result);
        verify(jsonArray, never()).put(jsonObject);
    }

    @Test
    public void serializer_serializesNullIntoEmptyArray() {
        JSONArray result = new ArraySerializer().serialize(null);
        assertSame(jsonArray, result);
        verify(jsonArray, never()).put(jsonObject);
    }
}
