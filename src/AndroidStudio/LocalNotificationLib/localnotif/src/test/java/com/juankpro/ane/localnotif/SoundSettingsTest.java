package com.juankpro.ane.localnotif;

import android.app.Notification;
import android.net.Uri;
import android.os.Bundle;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static junit.framework.Assert.assertNull;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;
import static org.powermock.api.mockito.PowerMockito.verifyStatic;

/**
 * Created by juancarlospazmino on 12/14/17.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({
        Uri.class,
        Bundle.class
})
public class SoundSettingsTest {
    @Mock
    private Bundle bundle;
    @Mock
    private Uri uri;
    private SoundSettings subject;
    private SoundSettings getSubject() {
        if (subject == null) { subject = new SoundSettings(bundle); }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);

        PowerMockito.mockStatic(Uri.class);
        when(Uri.parse(anyString())).thenReturn(uri);
    }

    @Test
    public void settings_getSoundUri_returnsUriIfBundlePlaysSoundAndHasSoundName() {
        when(bundle.getString(Constants.SOUND_NAME)).thenReturn("sound.mp3");
        when(bundle.getBoolean(Constants.PLAY_SOUND)).thenReturn(true);
        assertNotNull(getSubject().getSoundUri());

        verifyStatic(Uri.class);
        Uri.parse("content://com.juankpro.ane.localnotif.notification_sound_provider/sound.mp3");
    }

    @Test
    public void settings_getSoundUri_returnsNullIfBundlePlaysSoundAndDoesNotHaveSoundName() {
        when(bundle.getBoolean(Constants.PLAY_SOUND)).thenReturn(true);
        assertNull(getSubject().getSoundUri());

        when(bundle.getString(Constants.SOUND_NAME)).thenReturn("");
        when(bundle.getBoolean(Constants.PLAY_SOUND)).thenReturn(true);
        assertNull(getSubject().getSoundUri());
    }

    @Test
    public void settings_getSoundUri_returnsNullIfBundleDoesNotPlaySoundAndHasSoundName() {
        when(bundle.getString(Constants.SOUND_NAME)).thenReturn("sound.mp3");
        assertNull(getSubject().getSoundUri());
    }

    @Test
    public void settings_getSoundUri_returnsNullIfBundleDoesNotPlaySoundAndDoesNotHaveSoundName() {
        assertNull(getSubject().getSoundUri());
    }

    @Test
    public void settings_getSoundDefault_returnsZeroIfBundlePlaysSoundAndDoesNotHaveSoundName() {
        when(bundle.getBoolean(Constants.PLAY_SOUND)).thenReturn(true);
        assertEquals(Notification.DEFAULT_SOUND, getSubject().getSoundDefault());
    }

    @Test
    public void settings_getSoundDefault_returnsZeroIfBundlePlaysSoundAndHasSoundName() {
        when(bundle.getString(Constants.SOUND_NAME)).thenReturn("sound.mp3");
        when(bundle.getBoolean(Constants.PLAY_SOUND)).thenReturn(true);
        assertEquals(0, getSubject().getSoundDefault());
    }

    @Test
    public void settings_getSoundDefault_returnsZeroIfBundleDoesNotPlaySoundAndHasSoundName() {
        when(bundle.getString(Constants.SOUND_NAME)).thenReturn("sound.mp3");
        when(bundle.getBoolean(Constants.PLAY_SOUND)).thenReturn(false);
        assertEquals(0, getSubject().getSoundDefault());
    }

    @Test
    public void settings_getSoundDefault_returnsZeroIfBundleDoesNotPlaySoundAndDoesNotHaveSoundName() {
        assertEquals(0, getSubject().getSoundDefault());
    }
}
