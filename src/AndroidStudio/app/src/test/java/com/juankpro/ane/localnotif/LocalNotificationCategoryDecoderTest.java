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

import static org.junit.Assert.assertEquals;
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
        return getSubject(true);
    }

    private LocalNotificationCategoryDecoder getSubject(boolean allowBackgroundActions) {
        if (subject == null) {
            subject = new LocalNotificationCategoryDecoder(freContext, allowBackgroundActions);
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
    public void decoder_decode_decodesActions_whenBackgroundActionsAreAllowed() {
        LocalNotificationAction action = new LocalNotificationAction();
        LocalNotificationAction[] actions = new LocalNotificationAction[]{action};
        LocalNotificationActionDecoder decoder = new LocalNotificationActionDecoder(freContext, true);

        try {
            PowerMockito.whenNew(LocalNotificationActionDecoder.class)
                    .withArguments(freContext, true)
                    .thenReturn(decoder);
        } catch (Throwable e) { e.printStackTrace(); }

        when(ExtensionUtils.getArrayProperty(freContext, freObject, "actions", decoder, LocalNotificationAction.class))
                .thenReturn(actions);

        assertSame(actions, getSubject().decodeObject(freObject).actions);
    }

    @Test
    public void decoder_decode_decodesActions_whenBackgroundActionsAreNotAllowed() {
        LocalNotificationAction[] actions = new LocalNotificationAction[0];
        LocalNotificationActionDecoder decoder = new LocalNotificationActionDecoder(freContext, false);

        try {
            PowerMockito.whenNew(LocalNotificationActionDecoder.class)
                    .withArguments(freContext, false)
                    .thenReturn(decoder);
        } catch (Throwable e) { e.printStackTrace(); }

        when(ExtensionUtils.getArrayProperty(freContext, freObject, "actions", decoder, LocalNotificationAction.class))
                .thenReturn(actions);

        assertSame(actions, getSubject(false).decodeObject(freObject).actions);
    }
}
