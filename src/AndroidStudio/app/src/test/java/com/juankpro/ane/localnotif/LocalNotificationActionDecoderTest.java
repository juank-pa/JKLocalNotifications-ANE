package com.juankpro.ane.localnotif;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.juankpro.ane.localnotif.decoder.LocalNotificationActionDecoder;
import com.juankpro.ane.localnotif.fre.ExtensionUtils;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;

/**
 * Created by juank on 11/25/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest(ExtensionUtils.class)
public class LocalNotificationActionDecoderTest {
    @Mock
    private FREObject freObject;
    @Mock
    private FREContext freContext;
    private LocalNotificationActionDecoder subject;

    private LocalNotificationActionDecoder getSubject() {
        if (subject == null) {
            subject = new LocalNotificationActionDecoder(freContext);
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        PowerMockito.mockStatic(ExtensionUtils.class);
    }

    @Test
    public void decoder_decode_decodesTitle() {
        when(ExtensionUtils.getStringProperty(freObject, "title", "")).thenReturn("Title");
        assertEquals("Title", getSubject().decodeObject(freObject).title);
    }

    @Test
    public void decoder_decode_decodesIdentifier() {
        when(ExtensionUtils.getStringProperty(freObject, "identifier", "")).thenReturn("MyId");
        assertEquals("MyId", getSubject().decodeObject(freObject).identifier);
    }
}
