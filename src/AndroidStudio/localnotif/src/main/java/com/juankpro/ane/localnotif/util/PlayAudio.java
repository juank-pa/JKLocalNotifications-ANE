package com.juankpro.ane.localnotif.util;

import android.app.Service;
import android.content.Intent;
import android.content.res.AssetFileDescriptor;
import android.media.MediaPlayer;
import android.os.IBinder;

import com.juankpro.ane.localnotif.Constants;

/**
 * Created by juancarlospazmino on 12/14/17.
 */

public class PlayAudio extends Service implements MediaPlayer.OnPreparedListener, MediaPlayer.OnCompletionListener {
    public int onStartCommand(Intent intent, int flags, int startId){
        String soundName = intent.getStringExtra(Constants.SOUND_NAME);
        playSound(soundName);
        return Service.START_NOT_STICKY;
    }

    private void playSound(String soundName) {
        AssetFileDescriptor audioFileDescriptor =
                new AssetDecompressor(getBaseContext()).decompress(soundName);
        MediaPlayer mediaPlayer = new MediaPlayer();
        prepareMediaPlayer(mediaPlayer, audioFileDescriptor);
    }

    private void prepareMediaPlayer(MediaPlayer mediaPlayer, AssetFileDescriptor audioFileDescriptor) {
        try {
            mediaPlayer.setDataSource(audioFileDescriptor.getFileDescriptor());
            audioFileDescriptor.close();
            mediaPlayer.setOnPreparedListener(this);
            mediaPlayer.setOnCompletionListener(this);
            mediaPlayer.prepareAsync();
        }
        catch (Throwable e) {
            e.printStackTrace();
        }
    }

    public void onPrepared(MediaPlayer mediaPlayer) {
        mediaPlayer.start();
    }

    public void onCompletion(MediaPlayer mediaPlayer) {
        mediaPlayer.stop();
        mediaPlayer.release();
        stopSelf();
    }

    @Override
    public IBinder onBind(Intent objIndent) {
        return null;
    }
}