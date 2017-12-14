package com.juankpro.ane.localnotif;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.juankpro.ane.localnotif.category.LocalNotificationCategory;
import com.juankpro.ane.localnotif.decoder.LocalNotificationCategoryDecoder;
import com.juankpro.ane.localnotif.decoder.LocalNotificationSettingsDecoder;
import com.juankpro.ane.localnotif.fre.ExtensionUtils;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.when;

import static org.junit.Assert.*;

/**
 * Created by juank on 11/24/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({LocalNotificationSettingsDecoder.class, ExtensionUtils.class})
public class LocalNotificationSettingsDecoderTest {
    @Mock
    private FREContext freContext;
    @Mock
    private FREObject freObject;
    private LocalNotificationSettingsDecoder subject;

    private LocalNotificationSettingsDecoder getSubject() {
        if (subject == null) {
            subject = spy(new LocalNotificationSettingsDecoder(freContext));
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        PowerMockito.mockStatic(ExtensionUtils.class);
    }

    @Test
    public void context_functions_registerSettings_whenBackgroundActionsAreAllowed() {
        LocalNotificationCategory category = new LocalNotificationCategory();
        LocalNotificationCategory[] categories = new LocalNotificationCategory[]{category};
        LocalNotificationCategoryDecoder decoder = new LocalNotificationCategoryDecoder(freContext, true);
        when(ExtensionUtils.getBooleanProperty(freObject, "allowAndroidBackgroundNotificationActions", false)).thenReturn(true);

        try {
            PowerMockito.whenNew(LocalNotificationCategoryDecoder.class)
                    .withArguments(freContext, true)
                    .thenReturn(decoder);
        } catch (Throwable e) { e.printStackTrace(); }

        when(ExtensionUtils.getArrayProperty(freContext, freObject, "categories", decoder, LocalNotificationCategory.class))
                .thenReturn(categories);

        assertSame(categories, getSubject().decodeObject(freObject).categories);
    }

    @Test
    public void context_functions_registerSettings_whenBackgroundActionsAreNotAllowed() {
        LocalNotificationCategory[] categories = new LocalNotificationCategory[0];
        LocalNotificationCategoryDecoder decoder = new LocalNotificationCategoryDecoder(freContext, false);
        when(ExtensionUtils.getBooleanProperty(freObject, "allowAndroidBackgroundNotificationActions", false)).thenReturn(false);

        try {
            PowerMockito.whenNew(LocalNotificationCategoryDecoder.class)
                    .withArguments(freContext, false)
                    .thenReturn(decoder);
        } catch (Throwable e) { e.printStackTrace(); }

        when(ExtensionUtils.getArrayProperty(freContext, freObject, "categories", decoder, LocalNotificationCategory.class))
                .thenReturn(categories);

        assertSame(categories, getSubject().decodeObject(freObject).categories);
    }
}
