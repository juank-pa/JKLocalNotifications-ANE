package com.juankpro.ane.localnotif.util;

import android.content.Context;
import android.content.SharedPreferences;

import com.juankpro.ane.localnotif.Constants;
import com.juankpro.ane.localnotif.LocalNotification;
import com.juankpro.ane.localnotif.category.LocalNotificationCategory;
import com.juankpro.ane.localnotif.serialization.IDeserializable;
import com.juankpro.ane.localnotif.serialization.ISerializable;

import org.json.JSONObject;

import java.util.Map;
import java.util.Set;

/**
 * Created by juank on 11/23/2017.
 */

public class PersistenceManager {
    private Context context;

    public PersistenceManager(Context context) {
        this.context = context;
    }

    public void writeNotification(LocalNotification notification) {
        writeObject(Constants.NOTIFICATION_CONFIG, notification.code, notification);
    }

    public LocalNotification readNotification(String identifier) {
        return readObject(Constants.NOTIFICATION_CONFIG, identifier, LocalNotification.class);
    }

    public void removeNotification(String notificationCode) {
        SharedPreferences.Editor editor = getEditor(Constants.NOTIFICATION_CONFIG);
        editor.remove(notificationCode);
        editor.commit();
    }

    public void clearNotifications() {
        clearPrefs(Constants.NOTIFICATION_CONFIG);
    }

    public Set<String> readNotificationKeys() {
        final SharedPreferences alarmSettings = getPreferences(Constants.NOTIFICATION_CONFIG);
        return alarmSettings.getAll().keySet();
    }

    public void writeCategories(LocalNotificationCategory[] categories) {
        final SharedPreferences.Editor editor = getEditor(Constants.CATEGORY_CONFIG);
        for (LocalNotificationCategory category : categories) {
            writeObject(editor, category.identifier, category);
        }
        editor.commit();
    }

    public LocalNotificationCategory readCategory(String identifier) {
        return readObject(Constants.CATEGORY_CONFIG, identifier, LocalNotificationCategory.class);
    }

    private void clearPrefs(String prefCategory) {
        SharedPreferences.Editor editor = getEditor(prefCategory);
        editor.clear();
        editor.commit();
    }

    private JSONObject readEntry(String category, String entryId) {
        final SharedPreferences prefs = getPreferences(category);
        String serializedSetting = prefs.getString(entryId, null);
        JSONObject categoryObject = null;

        if (serializedSetting == null) return null;

        try {
            categoryObject = new JSONObject(serializedSetting);
        }
        catch (Throwable e) {
            e.printStackTrace();
        }
        return categoryObject;
    }

    private SharedPreferences getPreferences(String category) {
        return context.getSharedPreferences(category, Context.MODE_PRIVATE);
    }

    private SharedPreferences.Editor getEditor(String category) {
        return getPreferences(category).edit();
    }

    private void writeObject(String category, String identifier, ISerializable object) {
        final SharedPreferences.Editor editor = getEditor(category);
        writeObject(editor, identifier, object);
        editor.commit();
    }

    private <T extends IDeserializable> T readObject(String category, String identifier, Class<T> objClass) {
        T object = null;
        try {
            object = objClass.newInstance();
            object.deserialize(readEntry(category, identifier));
        }
        catch (Throwable e) {
            e.printStackTrace();
        }
        return object;
    }

    private void writeObject(SharedPreferences.Editor editor, String identifier, ISerializable object) {
        editor.putString(identifier, object.serialize().toString());
    }
}
