package com.juankpro.ane.localnotif;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.juankpro.ane.localnotif.category.LocalNotificationAction;
import com.juankpro.ane.localnotif.decoder.LocalNotificationActionDecoder;
import com.juankpro.ane.localnotif.decoder.LocalNotificationCategoryDecoder;
import com.juankpro.ane.localnotif.fre.ExtensionUtils;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static junit.framework.Assert.assertTrue;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertSame;
import static org.mockito.Mockito.when;

/**
 * Created by juank on 11/25/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({LocalNotificationCategoryDecoder.class, ExtensionUtils.class})
public class LocalNotificationCategoryDecoderTest {
    @Mock
    private FREObject freObject;
    @Mock
    private FREContext freContext;
    private LocalNotificationCategoryDecoder subject;

    private LocalNotificationCategoryDecoder getSubject() {
        if (subject == null) {
            subject = new LocalNotificationCategoryDecoder(freContext);
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        PowerMockito.mockStatic(ExtensionUtils.class);
    }

    @Test
    public void decoder_decode_decodesIdentifier() {
        when(ExtensionUtils.getStringProperty(freObject, "identifier", "")).thenReturn("MyId");
        assertEquals("MyId", getSubject().decodeObject(freObject).identifier);
    }

    @Test
    public void decoder_decode_decodesUseCustomDismissAction() {
        assertFalse(getSubject().decodeObject(freObject).useCustomDismissAction);
        when(ExtensionUtils.getBooleanProperty(freObject, "useCustomDismissAction", false)).thenReturn(true);
        assertTrue(getSubject().decodeObject(freObject).useCustomDismissAction);
    }

    @Test
    public void decoder_decode_decodesName() {
        when(ExtensionUtils.getStringProperty(freObject, "name", null)).thenReturn("Category Name");
        assertEquals("Category Name", getSubject().decodeObject(freObject).name);
    }

    @Test
    public void decoder_decode_decodesDescription() {
        when(ExtensionUtils.getStringProperty(freObject, "description", null)).thenReturn("Category Description");
        assertEquals("Category Description", getSubject().decodeObject(freObject).description);
    }

    @Test
    public void decoder_decode_decodesSoundName() {
        when(ExtensionUtils.getStringProperty(freObject, "soundName", null)).thenReturn("sound.mp3");
        assertEquals("sound.mp3", getSubject().decodeObject(freObject).soundName);
    }

    @Test
    public void decoder_decode_decodesImportance() {
        when(ExtensionUtils.getIntProperty(freObject, "importance", 0)).thenReturn(5);
        assertEquals(5, getSubject().decodeObject(freObject).importance);
    }

    @Test
    public void decoder_decode_decodesShouldVibrate() {
        when(ExtensionUtils.getBooleanProperty(freObject, "shouldVibrate", false)).thenReturn(true);
        assertTrue(getSubject().decodeObject(freObject).shouldVibrate);
    }

    @Test
    public void decoder_decode_decodesActions() {
        LocalNotificationAction action = new LocalNotificationAction();
        LocalNotificationAction[] actions = new LocalNotificationAction[]{action};
        LocalNotificationActionDecoder decoder = new LocalNotificationActionDecoder(freContext);

        try {
            PowerMockito.whenNew(LocalNotificationActionDecoder.class)
                    .withArguments(freContext)
                    .thenReturn(decoder);
        } catch (Throwable e) { e.printStackTrace(); }

        when(ExtensionUtils.getArrayProperty(freContext, freObject, "actions", decoder, LocalNotificationAction.class))
                .thenReturn(actions);

        assertSame(actions, getSubject().decodeObject(freObject).actions);
    }
}
