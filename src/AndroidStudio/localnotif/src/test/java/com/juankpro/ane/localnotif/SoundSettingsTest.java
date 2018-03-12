package com.juankpro.ane.localnotif;

import android.app.Notification;
import android.os.Bundle;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.when;

/**
 * Created by juancarlospazmino on 12/14/17.
 */

public class SoundSettingsTest {
    @Mock
    private Bundle bundle;
    private SoundSettings subject;
    private SoundSettings getSubject() {
        if (subject == null) { subject = new SoundSettings(bundle); }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    public void settings_getSoundName_returnsTheSoundName() {
        when(bundle.getString(Constants.SOUND_NAME)).thenReturn("sound.mp3");
        assertEquals("sound.mp3", getSubject().getSoundName());
    }

    @Test
    public void settings_shouldPlayCustomSound_returnsTrueIfBundlePlaysSoundAndHasSoundName() {
        when(bundle.getString(Constants.SOUND_NAME)).thenReturn("sound.mp3");
        when(bundle.getBoolean(Constants.PLAY_SOUND)).thenReturn(true);
        assertTrue(getSubject().shouldPlayCustomSound());
    }

    @Test
    public void settings_shouldPlayCustomSound_returnsFalseIfBundlePlaysSoundAndDoesNotHaveSoundName() {
        when(bundle.getBoolean(Constants.PLAY_SOUND)).thenReturn(true);
        assertFalse(getSubject().shouldPlayCustomSound());
    }

    @Test
    public void settings_shouldPlayCustomSound_returnsFalseIfBundleDoesNotPlaySoundAndHasSoundName() {
        when(bundle.getString(Constants.SOUND_NAME)).thenReturn("sound.mp3");
        assertFalse(getSubject().shouldPlayCustomSound());
    }

    @Test
    public void settings_shouldPlayCustomSound_returnsFalseIfBundleDoesNotPlaySoundAndDoesNotHaveSoundName() {
        assertFalse(getSubject().shouldPlayCustomSound());
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
