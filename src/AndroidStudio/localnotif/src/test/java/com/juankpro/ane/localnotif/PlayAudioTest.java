package com.juankpro.ane.localnotif;

import android.content.Context;
import android.content.Intent;
import android.content.res.AssetFileDescriptor;
import android.media.MediaPlayer;

import com.juankpro.ane.localnotif.util.AssetDecompressor;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InOrder;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import java.io.FileDescriptor;
import java.io.IOException;

import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.inOrder;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Created by juancarlospazmino on 12/14/17.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({PlayAudio.class,FileDescriptor.class})
public class PlayAudioTest {
    @Mock
    private Context context;
    @Mock
    private AssetFileDescriptor assetFileDescriptor;
    private FileDescriptor fileDescriptor;
    @Mock
    private MediaPlayer mediaPlayer;
    @Mock
    private Intent intent;
    @Mock
    private AssetDecompressor decompressor;

    private PlayAudio subject;

    private PlayAudio getSubject() {
        if (subject == null) {
            subject = spy(new PlayAudio());
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        fileDescriptor = PowerMockito.mock(FileDescriptor.class);
    }

    @Test
    public void service_onStartCommand_decompressesAndPreparesAudioForMediaPlayer() {
        try {
            PowerMockito.whenNew(AssetDecompressor.class)
                    .withArguments(context)
                    .thenReturn(decompressor);
            PowerMockito.whenNew(MediaPlayer.class)
                    .withNoArguments()
                    .thenReturn(mediaPlayer);
        } catch (Throwable e) { e.printStackTrace(); }

        when(decompressor.decompress("sound.mp3")).thenReturn(assetFileDescriptor);
        when(assetFileDescriptor.getFileDescriptor()).thenReturn(fileDescriptor);
        when(intent.getStringExtra(Constants.SOUND_NAME)).thenReturn("sound.mp3");
        doReturn(context).when(getSubject()).getBaseContext();

        getSubject().onStartCommand(intent, 0, 0);

        InOrder inOrder = inOrder(mediaPlayer, assetFileDescriptor);
        try {
            inOrder.verify(mediaPlayer).setDataSource(fileDescriptor);
            inOrder.verify(assetFileDescriptor).close();
        } catch (IOException e) { e.printStackTrace(); }
        verify(mediaPlayer).setOnPreparedListener(getSubject());
        verify(mediaPlayer).setOnCompletionListener(getSubject());
    }

    @Test
    public void service_onPrepared_playsTheSound() {
        getSubject().onPrepared(mediaPlayer);
        verify(mediaPlayer).start();
    }

    @Test
    public void service_onCompletion_releasesTheSound() {
        doNothing().when(getSubject()).stopSelf();

        getSubject().onCompletion(mediaPlayer);

        InOrder inOrder = inOrder(mediaPlayer, mediaPlayer);
        inOrder.verify(mediaPlayer).stop();
        inOrder.verify(mediaPlayer).release();
    }

    @Test
    public void service_onCompletion_stopsTheService() {
        doNothing().when(getSubject()).stopSelf();
        getSubject().onCompletion(mediaPlayer);
        verify(getSubject()).stopSelf();
    }
}
