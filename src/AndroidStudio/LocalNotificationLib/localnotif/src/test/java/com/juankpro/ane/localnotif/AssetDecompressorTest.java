package com.juankpro.ane.localnotif;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.os.ParcelFileDescriptor;

import com.juankpro.ane.localnotif.util.AssetDecompressor;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.when;

/**
 * Created by juancarlospazmino on 12/14/17.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({AssetDecompressor.class,ParcelFileDescriptor.class})
public class AssetDecompressorTest {
    @Mock
    private Context context;
    @Mock
    private File file;
    @Mock
    private ParcelFileDescriptor parcel;
    @Mock
    private AssetFileDescriptor fileDescriptor;

    private AssetDecompressor subject;
    private AssetDecompressor getSubject() {
        if (subject == null) {
            subject = spy(new AssetDecompressor(context));
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        when(context.getCacheDir()).thenReturn(file);

        try {
            PowerMockito.whenNew(File.class).withArguments(file, "sound.mp3")
                    .thenReturn(file);

            PowerMockito.mockStatic(ParcelFileDescriptor.class);
            when(ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY)).thenReturn(parcel);

            PowerMockito.whenNew(AssetFileDescriptor.class).withArguments(parcel, 0L, -1L)
                    .thenReturn(fileDescriptor);
        } catch (Exception e) { e.printStackTrace(); }
    }

    @Test(expected = Test.None.class)
    public void decompressor_decompress_whenFileIsAlreadyCached_usesCache() throws FileNotFoundException {
        when(file.exists()).thenReturn(true);
        assertSame(fileDescriptor, getSubject().decompress("sound.mp3"));
    }

    @Test(expected = Test.None.class)
    public void decompressor_decompress_whenFileNotCached_decompresses() throws FileNotFoundException {
        when(file.exists()).thenReturn(false);
        when(file.getParentFile()).thenReturn(file);

        AssetManager am = mock(AssetManager.class);
        InputStream inputStream = mock(InputStream.class);
        FileOutputStream outputStream = mock(FileOutputStream.class);
        when(context.getAssets()).thenReturn(am);

        try {
            when(am.open("sound.mp3", AssetManager.ACCESS_BUFFER)).thenReturn(inputStream);
            when(inputStream.read(any(byte[].class))).thenReturn(-1);

            PowerMockito.whenNew(FileOutputStream.class).withArguments(file, false).thenReturn(outputStream);
        } catch (Exception e) { e.printStackTrace(); }

        assertSame(fileDescriptor, getSubject().decompress("sound.mp3"));
    }

    @Test
    public void decompressor_decompress_whenAnyExceptionIsThrownReturnsNull() {
        when(file.exists()).thenReturn(true);
        try {
            when(ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY)).thenThrow(Exception.class);
        } catch (Exception e) { e.printStackTrace(); }
        assertNull(getSubject().decompress("sound.mp3"));
    }
}