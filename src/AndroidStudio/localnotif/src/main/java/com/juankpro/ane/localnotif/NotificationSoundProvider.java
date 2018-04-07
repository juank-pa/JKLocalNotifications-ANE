package com.juankpro.ane.localnotif;

import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.Context;
import android.content.pm.ProviderInfo;
import android.content.res.AssetFileDescriptor;
import android.database.Cursor;
import android.net.Uri;

import com.juankpro.ane.localnotif.util.AssetDecompressor;

import java.io.FileNotFoundException;

public class NotificationSoundProvider extends ContentProvider {
    public static String AUTHORITY = "com.juankpro.ane.localnotif.notification_sound_provider";
    public static String CONTENT_URI = "content://" + AUTHORITY;

    public static Uri getSoundUri(String soundName) {
        return Uri.parse(CONTENT_URI + "/" + soundName);
    }

    public NotificationSoundProvider() {
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
    public void attachInfo(Context context, ProviderInfo info) {
        super.attachInfo(context, info);

        AUTHORITY = info.authority;
        CONTENT_URI = "content://" + AUTHORITY;
    }

    @Override
    public AssetFileDescriptor openAssetFile(Uri uri, String mode) throws FileNotFoundException {
        String lastPathSegment = uri.getLastPathSegment();
        if (!lastPathSegment.endsWith(".wav") && !lastPathSegment.endsWith(".mp3")) {
            throw new FileNotFoundException();
        }
        return new AssetDecompressor(getContext()).decompress(uri.getLastPathSegment());
    }
}
