package com.juankpro.ane.localnotif;

import android.app.Notification;
import android.net.Uri;
import android.os.Bundle;

/**
 * Created by juancarlospazmino on 12/14/17.
 */

public class SoundSettings {
    private Bundle bundle;

    public SoundSettings(Bundle bundle) {
        this.bundle = bundle;
    }

    private boolean shouldPlayDefaultSound() {
        return shouldPlaySound() && getSoundName() == null;
    }

    private boolean shouldPlaySound() {
        return bundle.getBoolean(Constants.PLAY_SOUND);
    }

    private String getSoundName() {
        String soundName = bundle.getString(Constants.SOUND_NAME);
        return soundName != null && soundName.length() > 0 && shouldPlaySound()? soundName : null;
    }

    public Uri getSoundUri() {
        String soundName = getSoundName();
        if (soundName == null) return null;
        return NotificationSoundProvider.getSoundUri(soundName);
    }

    public int getSoundDefault() {
        return shouldPlayDefaultSound()? Notification.DEFAULT_SOUND : 0;
    }
}
