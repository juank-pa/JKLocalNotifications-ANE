package com.juankpro.ane.localnotif;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.juankpro.ane.localnotif.decoder.ArrayDecoder;
import com.juankpro.ane.localnotif.decoder.IDecoder;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.junit.Assert.assertArrayEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

/**
 * Created by juank on 11/25/2017.
 */

@RunWith(PowerMockRunner.class)
public class ArrayDecoderTest {
    @Mock
    private FREArray freArray;
    @Mock
    private FREContext freContext;
    @Mock
    private IDecoder<LocalNotification> freDecoder;
    private ArrayDecoder<LocalNotification> subject;

    private ArrayDecoder<LocalNotification> getSubject() {
        if (subject == null) {
            subject = new ArrayDecoder<>(freContext, freDecoder, LocalNotification.class);
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);

        try {
            when(freArray.getLength()).thenReturn((long)1);
        } catch (Throwable e) { e.printStackTrace(); }
    }

    @Test
    public void decoder_decode_decodesAFreCodedArray() {
        LocalNotification decodedNotification = new LocalNotification();
        FREObject arrayItem = mock(FREObject.class);

        when(freDecoder.decodeObject(arrayItem)).thenReturn(decodedNotification);
        try {
            when(freArray.getObjectAt(0)).thenReturn(arrayItem);
        } catch (Throwable e) { e.printStackTrace(); }

        assertArrayEquals(
                new LocalNotification[]{decodedNotification},
                getSubject().decodeObject(freArray)
        );
    }

    @Test
    public void decoder_decode_whenCodedArrayIsEmpty_returnsEmptyArray() {
        try {
            when(freArray.getLength()).thenReturn((long)0);
        } catch (Throwable e) { e.printStackTrace(); }

        assertArrayEquals(new LocalNotification[]{}, getSubject().decodeObject(freArray));
    }

    @Test
    public void decoder_decode_whenThereIsAnyException_returnsEmptyArray() {
        try {
            when(freArray.getObjectAt(0)).thenThrow(mock(FREInvalidObjectException.class));
        } catch (Throwable e) { e.printStackTrace(); }

        assertArrayEquals(new LocalNotification[]{}, getSubject().decodeObject(freArray));

        try {
            when(freArray.getLength()).thenThrow(mock(FREInvalidObjectException.class));
        } catch (Throwable e) { e.printStackTrace(); }

        assertArrayEquals(new LocalNotification[]{}, getSubject().decodeObject(freArray));
    }
}
