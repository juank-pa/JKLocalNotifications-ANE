package com.juankpro.ane.localnotif;

import android.app.Activity;
import android.os.Build;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.juankpro.ane.localnotif.decoder.LocalNotificationDecoder;
import com.juankpro.ane.localnotif.fre.ExtensionUtils;
import com.juankpro.ane.localnotif.util.ResourceMapper;

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

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.same;
import static org.mockito.Mockito.when;

/**
 * Created by juank on 11/21/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({ExtensionUtils.class,LocalNotificationDecoder.class,Build.VERSION.class})
public class
LocalNotificationDecoderTest {
    @Mock
    private FREObject freArg1;
    @Mock
    private FREObject freArg2;
    @Mock
    private FREContext freContext;
    @Mock
    private Activity activity;
    @Mock
    private ResourceMapper mapper;
    private LocalNotificationDecoder subject;

    private LocalNotificationDecoder getSubject() {
        if (subject == null) {
            subject = new LocalNotificationDecoder(freContext, freArg1);
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        when(freContext.getActivity()).thenReturn(activity);
        PowerMockito.mockStatic(ExtensionUtils.class);
    }

    @Test
    public void decoder_storesClassNameFromContextInDecodedNotification() {
        assertTrue(getSubject().decodeObject(freArg2).activityClassName.matches("^android\\.app\\.Activity\\$MockitoMock\\$\\d+"));
    }

    @Test
    public void decoder_decode_decodesLocalNotificationCode() {
        try { when(freArg1.getAsString()).thenReturn("My Code"); }
        catch (Throwable e) { e.printStackTrace(); }
        assertEquals("My Code", getSubject().decodeObject(freArg2).code);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationFireDate() {
        Date testDate = new Date();
        when(ExtensionUtils.getDateProperty(same(freArg2), eq("fireDate"), any(Date.class))).thenReturn(testDate);
        assertSame(testDate, getSubject().decodeObject(freArg2).fireDate);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationRepeatInterval() {
        when(ExtensionUtils.getIntProperty(freArg2, "repeatInterval", 0)).thenReturn(20);
        assertEquals(20, getSubject().decodeObject(freArg2).repeatInterval);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationTickerText() {
        when(ExtensionUtils.getStringProperty(freArg2, "tickerText", "")).thenReturn("Ticker");
        assertEquals("Ticker", getSubject().decodeObject(freArg2).tickerText);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationTitle() {
        when(ExtensionUtils.getStringProperty(freArg2, "title", "")).thenReturn("Title");
        assertEquals("Title", getSubject().decodeObject(freArg2).title);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationTickerBody() {
        when(ExtensionUtils.getStringProperty(freArg2, "body", "")).thenReturn("Body");
        assertEquals("Body", getSubject().decodeObject(freArg2).body);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationPlaySound() {
        when(ExtensionUtils.getBooleanProperty(freArg2, "playSound", false)).thenReturn(true);
        assertTrue(getSubject().decodeObject(freArg2).playSound);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationSoundName() {
        when(ExtensionUtils.getStringProperty(freArg2, "soundName", "")).thenReturn("sound.mp3");
        assertEquals("sound.mp3", getSubject().decodeObject(freArg2).soundName);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationVibrate() {
        when(ExtensionUtils.getBooleanProperty(freArg2, "vibrate", false)).thenReturn(true);
        assertTrue(getSubject().decodeObject(freArg2).vibrate);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationIconType() {
        when(ExtensionUtils.getStringProperty(freArg2, "iconType", "")).thenReturn("Icon");

        try {
            PowerMockito.whenNew(ResourceMapper.class).withNoArguments().thenReturn(mapper);
        } catch (Throwable e) { e.printStackTrace(); }
        when(mapper.getResourceIdFor("Icon", freContext)).thenReturn(1003);

        assertEquals(1003, getSubject().decodeObject(freArg2).iconResourceId);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationNumberAnnotation() {
        when(ExtensionUtils.getIntProperty(freArg2, "numberAnnotation", 0)).thenReturn(3);
        assertEquals(3, getSubject().decodeObject(freArg2).numberAnnotation);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationHasAction() {
        when(ExtensionUtils.getBooleanProperty(freArg2, "hasAction", true)).thenReturn(true);
        assertTrue(getSubject().decodeObject(freArg2).hasAction);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationShowInForeGround() {
        when(ExtensionUtils.getBooleanProperty(freArg2, "showInForeground", false)).thenReturn(true);
        assertTrue(getSubject().decodeObject(freArg2).showInForeground);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationCancelOnSelect() {
        when(ExtensionUtils.getBooleanProperty(freArg2, "cancelOnSelect", false)).thenReturn(true);
        assertTrue(getSubject().decodeObject(freArg2).cancelOnSelect);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationAlertPolicy() {
        when(ExtensionUtils.getStringProperty(freArg2, "alertPolicy", "")).thenReturn("policy");
        assertEquals("policy", getSubject().decodeObject(freArg2).alertPolicy);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationCancelOngoing() {
        when(ExtensionUtils.getBooleanProperty(freArg2, "ongoing", false)).thenReturn(true);
        assertTrue(getSubject().decodeObject(freArg2).ongoing);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationIsExact() {
        when(ExtensionUtils.getBooleanProperty(freArg2, "isExact", false)).thenReturn(true);
        assertTrue(getSubject().decodeObject(freArg2).isExact);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationAllowWhileIdle() {
        when(ExtensionUtils.getBooleanProperty(freArg2, "allowWhileIdle", false)).thenReturn(true);
        assertTrue(getSubject().decodeObject(freArg2).allowWhileIdle);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationPriority_zeroIfSdkLessThanNougat() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.N - 1);
        when(ExtensionUtils.getIntProperty(freArg2, "priority", 0)).thenReturn(12);
        assertEquals(12, getSubject().decodeObject(freArg2).priority);
    }

    @Test
    public void decoder_decode_decodesLocalNotificationActionData() {
        byte[] bytes = {0, 12};
        when(ExtensionUtils.getBytesProperty(freArg2, "actionData", new byte[]{})).thenReturn(bytes);
        assertSame(bytes, getSubject().decodeObject(freArg2).actionData);
    }
}
