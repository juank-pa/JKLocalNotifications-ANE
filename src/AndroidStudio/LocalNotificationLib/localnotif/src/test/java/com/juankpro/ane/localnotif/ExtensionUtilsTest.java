package com.juankpro.ane.localnotif;

import com.adobe.fre.FREASErrorException;
import com.adobe.fre.FREByteArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FRENoSuchNameException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.juankpro.ane.localnotif.category.LocalNotificationAction;
import com.juankpro.ane.localnotif.decoder.ArrayDecoder;
import com.juankpro.ane.localnotif.decoder.IDecoder;
import com.juankpro.ane.localnotif.fre.ExtensionUtils;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InOrder;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import java.nio.ByteBuffer;
import java.util.Date;

import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertNull;
import static junit.framework.Assert.assertSame;
import static org.junit.Assert.assertArrayEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Created by juank on 12/18/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({
        ExtensionUtils.class,
        ByteBuffer.class,
        ArrayDecoder.class,
        FREObject.class
})
public class ExtensionUtilsTest {
    @Mock
    private FREContext freContext;
    @Mock
    private FREObject freObject;
    @Mock
    private FREObject frePropertyObject;

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    public void utils_getStringProperty_returnsStringFromFreObject() {
        try {
            when(freObject.getProperty("propName")).thenReturn(frePropertyObject);
            when(frePropertyObject.getAsString()).thenReturn("value");
        } catch (Throwable e) { e.printStackTrace(); }

        assertEquals(
                "value",
                ExtensionUtils.getStringProperty(freObject, "propName", "defaultValue")
        );
    }

    @Test
    public void utils_getStringProperty_returnsDefaultString_onException() {
        try {
            when(freObject.getProperty("propName")).thenThrow(FREInvalidObjectException.class);
        } catch (Throwable e) { e.printStackTrace(); }

        assertEquals(
                "defaultValue",
                ExtensionUtils.getStringProperty(freObject, "propName", "defaultValue")
        );
    }

    @Test
    public void utils_getBooleanProperty_returnsBooleanFromFreObject() {
        try {
            when(freObject.getProperty("propName")).thenReturn(frePropertyObject);
            when(frePropertyObject.getAsBool()).thenReturn(true);
        } catch (Throwable e) { e.printStackTrace(); }

        assertEquals(
                true,
                ExtensionUtils.getBooleanProperty(freObject, "propName", true)
        );
    }

    @Test
    public void utils_getBooleanProperty_returnsDefaultString_onException() {
        try {
            when(freObject.getProperty("propName")).thenThrow(FREInvalidObjectException.class);
        } catch (Throwable e) { e.printStackTrace(); }

        assertEquals(
                false,
                ExtensionUtils.getBooleanProperty(freObject, "propName", false)
        );
    }

    @Test
    public void utils_getIntProperty_returnsIntFromFreObject() {
        try {
            when(freObject.getProperty("propName")).thenReturn(frePropertyObject);
            when(frePropertyObject.getAsInt()).thenReturn(200);
        } catch (Throwable e) { e.printStackTrace(); }

        assertEquals(
                200,
                ExtensionUtils.getIntProperty(freObject, "propName", 10)
        );
    }

    @Test
    public void utils_getIntProperty_returnsDefaultInt_onException() {
        try {
            when(freObject.getProperty("propName")).thenThrow(FREInvalidObjectException.class);
        } catch (Throwable e) { e.printStackTrace(); }

        assertEquals(
                10,
                ExtensionUtils.getIntProperty(freObject, "propName", 10)
        );
    }

    @Test
    public void utils_getDoubleProperty_returnsDoubleFromFreObject() {
        try {
            when(freObject.getProperty("propName")).thenReturn(frePropertyObject);
            when(frePropertyObject.getAsDouble()).thenReturn(200.5);
        } catch (Throwable e) { e.printStackTrace(); }

        assertEquals(
                200.5,
                ExtensionUtils.getDoubleProperty(freObject, "propName", 10.8)
        );
    }

    @Test
    public void utils_getDoubleProperty_returnsDefaultDouble_onException() {
        try {
            when(freObject.getProperty("propName")).thenThrow(FREInvalidObjectException.class);
        } catch (Throwable e) { e.printStackTrace(); }

        assertEquals(
                10.8,
                ExtensionUtils.getDoubleProperty(freObject, "propName", 10.8)
        );
    }

    @Test
    public void utils_getDateProperty_returnsDateFromFreObject() {
        FREObject freTimeProperty = mock(FREObject.class);
        Date date = mock(Date.class);

        try {
            PowerMockito
                    .whenNew(Date.class)
                    .withArguments((long)200)
                    .thenReturn(date);
            when(freObject.getProperty("propName")).thenReturn(frePropertyObject);
            when(frePropertyObject.getProperty("time")).thenReturn(freTimeProperty);
            when(freTimeProperty.getAsDouble()).thenReturn(200.0);
        } catch (Throwable e) { e.printStackTrace(); }

        assertSame(
                date,
                ExtensionUtils.getDateProperty(freObject, "propName", null)
        );
    }

    @Test
    public void utils_getDateProperty_returnsDefaultDate_onException() {
        Date date = mock(Date.class);
        try {
            when(freObject.getProperty("propName")).thenThrow(FREInvalidObjectException.class);
        } catch (Throwable e) { e.printStackTrace(); }

        assertSame(date, ExtensionUtils.getDateProperty(freObject, "propName", date));
    }

    @Test
    public void utils_getDateProperty_returnsCurrentDate_onExceptionAndNullDefault() {
        Date date = mock(Date.class);
        try {
            PowerMockito.whenNew(Date.class).withNoArguments().thenReturn(date);
            when(freObject.getProperty("propName")).thenThrow(FREInvalidObjectException.class);
        } catch (Throwable e) { e.printStackTrace(); }

        assertSame(
                date,
                ExtensionUtils.getDateProperty(freObject, "propName", null)
        );
    }

    @Test
    public void utils_getBytesProperty_returnsBytesFromFreObject() throws FREInvalidObjectException, FREWrongThreadException {
        FREByteArray freByteArray = mock(FREByteArray.class);
        final ByteBuffer byteBuffer = PowerMockito.mock(ByteBuffer.class);
        final byte value[] = new byte[2];
        byte defaultValue[] = new byte[3];

        try {
            when(freObject.getProperty("propName")).thenReturn(freByteArray);
            when(freByteArray.getBytes()).thenReturn(byteBuffer);
            when(byteBuffer.limit()).thenReturn(2);
        } catch (Throwable e) { e.printStackTrace(); }

        when(byteBuffer.get(value)).then(new Answer<ByteBuffer>() {
            @Override
            public ByteBuffer answer(InvocationOnMock invocation) throws Throwable {
                byte argValue[] = invocation.getArgument(0);
                argValue[0] = 20;
                argValue[1] = 30;
                return byteBuffer;
            }
        });

        assertEquals(
                2,
                ExtensionUtils.getBytesProperty(freObject, "propName", defaultValue).length
        );

        assertEquals(
                20,
                ExtensionUtils.getBytesProperty(freObject, "propName", defaultValue)[0]
        );

        assertEquals(
                30,
                ExtensionUtils.getBytesProperty(freObject, "propName", defaultValue)[1]
        );

        InOrder inOrder = Mockito.inOrder(freByteArray, freByteArray, freByteArray);

        inOrder.verify(freByteArray).acquire();
        inOrder.verify(freByteArray).getBytes();
        inOrder.verify(freByteArray).release();
    }

    @Test
    public void utils_getBytesProperty_returnsDefaultBytes_onException() {
        byte defaultValue[] = new byte[3];
        FREByteArray freByteArray = mock(FREByteArray.class);

        try {
            when(freObject.getProperty("propName")).thenReturn(freByteArray);
            when(freByteArray.getBytes()).thenThrow(FREInvalidObjectException.class);
        } catch (Throwable e) { e.printStackTrace(); }

        assertSame(
                defaultValue,
                ExtensionUtils.getBytesProperty(freObject, "propName", defaultValue)
        );
    }

    @Test
    public void utils_getArrayProperty_returnsBytesFromFreObject() {
        IDecoder decoder = mock(IDecoder.class);
        ArrayDecoder arrayDecoder = mock(ArrayDecoder.class);
        LocalNotificationAction array[] = new LocalNotificationAction[2];

        try {
            PowerMockito.whenNew(ArrayDecoder.class)
                    .withArguments(freContext, decoder, LocalNotificationAction.class)
                    .thenReturn(arrayDecoder);
            when(freObject.getProperty("propName")).thenReturn(frePropertyObject);
        } catch (Throwable e) { e.printStackTrace(); }

        when(arrayDecoder.decodeObject(frePropertyObject)).thenReturn(array);

        //noinspection unchecked
        assertSame(
                array,
                ExtensionUtils.getArrayProperty(
                        freContext,
                        freObject,
                        "propName",
                        decoder,
                        LocalNotificationAction.class
                )
        );
        verify(arrayDecoder).decodeObject(frePropertyObject);
    }

    @Test
    public void utils_getArrayProperty_returnsEmptyArrayOnException() {
        IDecoder decoder = mock(IDecoder.class);
        ArrayDecoder arrayDecoder = mock(ArrayDecoder.class);

        try {
            when(freObject.getProperty("propName")).thenThrow(FREInvalidObjectException.class);
        } catch (Throwable e) { e.printStackTrace(); }

        LocalNotificationAction[] actions = new LocalNotificationAction[1];
        when(arrayDecoder.decodeObject(frePropertyObject)).thenReturn(actions);

        //noinspection unchecked
        assertArrayEquals(
                new LocalNotificationAction[0],
                ExtensionUtils.getArrayProperty(
                        freContext,
                        freObject,
                        "propName",
                        decoder,
                        LocalNotificationAction.class
                )
        );
    }

    @Test
    public void utils_getFREObject_returnsFreObjectFromBytes() throws FRETypeMismatchException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException {
        FREObject byteArrayObject = mock(FREObject.class);
        FREObject freObject10 = mock(FREObject.class);
        FREObject freObject45 = mock(FREObject.class);

        try {
            PowerMockito.mockStatic(FREObject.class);
            when(FREObject.newObject("flash.utils.ByteArray", null))
                    .thenReturn(byteArrayObject);
            when(FREObject.newObject(10)).thenReturn(freObject10);
            when(FREObject.newObject(45)).thenReturn(freObject45);
        } catch (Throwable e) { e.printStackTrace(); }

        byte data[] = {10, 45};

        assertSame(byteArrayObject, ExtensionUtils.getFreObject(data));

        verify(byteArrayObject).callMethod("writeByte", new FREObject[]{freObject10});
        verify(byteArrayObject).callMethod("writeByte", new FREObject[]{freObject45});
    }

    @Test
    public void utils_getFREObject_returnsNullOnException() {
        FREObject byteArrayObject = mock(FREObject.class);

        try {
            PowerMockito.mockStatic(FREObject.class);
            when(FREObject.newObject("flash.utils.ByteArray", null))
                    .thenReturn(byteArrayObject);
            when(FREObject.newObject(10)).thenThrow(FREInvalidObjectException.class);
        } catch (Throwable e) { e.printStackTrace(); }

        byte data[] = {10, 45};

        assertNull(ExtensionUtils.getFreObject(data));
    }
}
