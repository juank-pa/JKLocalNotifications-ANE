package com.juankpro.ane.localnotif;

import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.database.Cursor;
import android.net.Uri;
import android.os.ParcelFileDescriptor;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

public class AssetProvider extends ContentProvider {
    public AssetProvider() {
    }

    @Override
    public int delete(Uri uri, String selection, String[] selectionArgs) {
        return 0;
    }

    @Override
    public String getType(Uri uri) {
        return null;
    }

    @Override
    public Uri insert(Uri uri, ContentValues values) {
        return null;
    }

    @Override
    public boolean onCreate() {
        return false;
    }

    @Override
    public Cursor query(Uri uri, String[] projection, String selection,
                        String[] selectionArgs, String sortOrder) {
        return null;
    }

    @Override
    public int update(Uri uri, ContentValues values, String selection,
                      String[] selectionArgs) {
        return 0;
    }

    private AssetFileDescriptor getFd(File cacheFile) throws FileNotFoundException {
        return new AssetFileDescriptor(ParcelFileDescriptor.open(cacheFile, ParcelFileDescriptor.MODE_READ_ONLY), 0, -1);
    }

    @Override
    public AssetFileDescriptor openAssetFile(final Uri uri, final String mode) throws FileNotFoundException {
        final String assetPath = uri.getLastPathSegment();

        try {
            final File cacheFile = new File(getContext().getCacheDir(), assetPath);

            if (cacheFile.exists()) {
                Logger.log("File already in cache.");
                return getFd(cacheFile);
            }

            Logger.log("Decompressing file: " + assetPath);
            cacheFile.getParentFile().mkdirs();
            copyToCacheFile(assetPath, cacheFile);
            return getFd(cacheFile);
        }
        catch (FileNotFoundException e) {
            Logger.log("FileNotFoundException: " + e.getMessage());
            throw e;
        }
        catch (IOException e) {
            Logger.log("Error: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    private void copyToCacheFile(final String assetPath, final File cacheFile) throws IOException {
        final InputStream inputStream = getContext().getAssets().open(assetPath, AssetManager.ACCESS_BUFFER);
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
