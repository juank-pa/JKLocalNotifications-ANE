package com.juankpro.ane.localnotif.util;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.os.ParcelFileDescriptor;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * Created by juancarlospazmino on 12/14/17.
 */

public class AssetDecompressor {
    private Context context;

    public AssetDecompressor(Context context) {
        this.context = context;
    }

    private AssetFileDescriptor getFd(File cacheFile) throws FileNotFoundException {
        return new AssetFileDescriptor(ParcelFileDescriptor.open(cacheFile, ParcelFileDescriptor.MODE_READ_ONLY), 0, -1);
    }

    @SuppressWarnings("ResultOfMethodCallIgnored")
    public AssetFileDescriptor decompress(String soundName) {
        try {
            final File cacheFile = new File(context.getCacheDir(), soundName);

            if (cacheFile.exists()) return getFd(cacheFile);

            cacheFile.getParentFile().mkdirs();
            copyToCacheFile(soundName, cacheFile);
            return getFd(cacheFile);
        }
        catch (Throwable e) {
            e.printStackTrace();
        }
        return null;
    }

    private void copyToCacheFile(final String assetPath, final File cacheFile) throws IOException {
        final InputStream inputStream = context.getAssets().open(assetPath, AssetManager.ACCESS_BUFFER);
        FileOutputStream outputStream = null;

        try {
            outputStream = new FileOutputStream(cacheFile, false);
            byte[] bytes = new byte[1024];
            int readAmount;
            while((readAmount = inputStream.read(bytes)) != -1) {
                outputStream.write(bytes, 0, readAmount);
            }
        }
        finally {
            if (inputStream != null) inputStream.close();
            if (outputStream != null) outputStream.close();
        }
    }
}
