package com.juankpro.ane.localnotif;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.net.Uri;
import android.os.ParcelFileDescriptor;

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
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.when;

import static org.junit.Assert.*;

/**
 * Created by Juank on 11/12/17.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({AssetProvider.class,ParcelFileDescriptor.class})
public class AssetProviderTest {
    @Mock
    private Context context;
    @Mock
    private File file;
    @Mock
    private Uri uri;
    @Mock
    private ParcelFileDescriptor parcel;
    @Mock
    private AssetFileDescriptor fileDescriptor;

    private AssetProvider subject;

    private AssetProvider getSubject() {
        if (subject == null) {
            subject = spy(new AssetProvider());
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);

        when(uri.getLastPathSegment()).thenReturn("sound.mp3");

        doReturn(context).when(getSubject()).getContext();
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
    public void provider_openAsset_whenFileIsAlreadyCached() throws FileNotFoundException {
        when(file.exists()).thenReturn(true);
        assertSame(fileDescriptor, getSubject().openAssetFile(uri, "mode"));
    }

    @Test(expected = Test.None.class)
    public void provider_openAsset_whenFileNotCached() throws FileNotFoundException {
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

        assertSame(fileDescriptor, getSubject().openAssetFile(uri, "mode"));
    }

    @Test(expected = FileNotFoundException.class)
    public void provider_openAsset_whenAnyExceptionIsThrown() throws FileNotFoundException {
        when(file.exists()).thenReturn(true);
        when(ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY)).thenThrow(Exception.class);
        getSubject().openAssetFile(uri, "mode");
    }
}
