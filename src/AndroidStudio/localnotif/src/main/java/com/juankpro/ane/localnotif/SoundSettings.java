package com.juankpro.ane.localnotif;

import android.app.Notification;
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

    boolean shouldPlayCustomSound() {
        return shouldPlaySound() && getSoundName() != null && getSoundName().length() > 0;
    }

    private boolean shouldPlaySound() {
        return bundle.getBoolean(Constants.PLAY_SOUND);
    }

    String getSoundName() {
        return bundle.getString(Constants.SOUND_NAME);
    }

    public int getSoundDefault() {
        return shouldPlayDefaultSound()? Notification.DEFAULT_SOUND : 0;
    }
}
