package com.juankpro.ane.localnotif;

import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.database.Cursor;
import android.net.Uri;

import java.io.FileNotFoundException;
import java.io.IOException;

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

    @Override
    public AssetFileDescriptor openAssetFile(Uri uri, String mode) throws FileNotFoundException {
        AssetManager manager = getContext().getAssets();
        String fileName = uri.getLastPathSegment();

        if (fileName == null) {
            throw new FileNotFoundException("Invalid asset path");
        }

        try {
            return manager.openFd(fileName);
        }
        catch (FileNotFoundException e) {
            throw e;
        }
        catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }
}
