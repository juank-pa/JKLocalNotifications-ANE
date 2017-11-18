package com.juankpro.ane.localnotif;


import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import android.app.NotificationManager;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

/**
 * Created by Juank on 10/22/17.
 */

class LocalNotification {
    String code = "";

    // Text.
    String tickerText = "";
    String title = "";
    String body = "";

    // Sound.
    boolean playSound = false;

    // Vibration.
    boolean vibrate = false;

    // Icon.
    int iconResourceId = 0;
    int numberAnnotation = 0;

    // Miscellaneous.
    boolean cancelOnSelect = false;
    boolean ongoing = false;
    String alertPolicy = "";

    String soundName = "";

    // Action.
    boolean hasAction = true;
    byte[] actionData = {};

    Date fireDate = new Date();
    int repeatInterval = 0;

    int priority = NotificationManager.IMPORTANCE_DEFAULT;

    boolean showInForeground = false;

    String activityClassName = "";

    /**
     * The activityClassName parameter can be null if you expect to call deserialize to retrieve it afterward.
     */
    LocalNotification(String activityClassName) {
        this.activityClassName = activityClassName;
    }


    void serialize(SharedPreferences prefs) {
        Editor editor = prefs.edit();

        JSONObject jsonObject = new JSONObject();

        try {
            jsonObject.putOpt("code", code);
            jsonObject.putOpt("tickerText", tickerText);
            jsonObject.putOpt("title", title);
            jsonObject.putOpt("body", body);
            jsonObject.putOpt("playSound", playSound);
            jsonObject.putOpt("vibrate", vibrate);
            jsonObject.putOpt("iconResourceId", iconResourceId);
            jsonObject.putOpt("numberAnnotation", numberAnnotation);
            jsonObject.putOpt("cancelOnSelect", cancelOnSelect);
            jsonObject.putOpt("ongoing", ongoing);
            jsonObject.putOpt("alertPolicy", alertPolicy);
            jsonObject.putOpt("hasAction", hasAction);
            jsonObject.putOpt("soundName", soundName);
            jsonObject.putOpt("fireDate", fireDate.getTime());
            jsonObject.putOpt("repeatInterval", repeatInterval);
            jsonObject.putOpt("activityClassName", activityClassName);
            jsonObject.putOpt("priority", priority);

            // Action data.
            for (byte anActionData : actionData) {
                jsonObject.accumulate("actionData", (int)anActionData);
            }
        } catch (Exception e) {
            Logger.log("LocalNotification::serialize Exception");
        }


        // Basic properties.
        editor.putString(code, jsonObject.toString());
        editor.commit();
    }


    void deserialize(SharedPreferences prefs, String code) {
        String jsonString = prefs.getString(code, "");
        JSONObject jsonObject = null;

        try {
            jsonObject = new JSONObject(jsonString);
        } catch (Exception e) {
            Logger.log("LocalNotification::deserialize No valid JSON string Exception");
        }

        if (jsonObject != null) {
            // Note: using the current value as the default value in each case.
            this.code = jsonObject.optString("code", code);
            tickerText = jsonObject.optString("tickerText", tickerText);
            title = jsonObject.optString("title", title);
            body = jsonObject.optString("body", body);
            playSound = jsonObject.optBoolean("playSound", playSound);
            vibrate = jsonObject.optBoolean("vibrate", vibrate);
            iconResourceId = jsonObject.optInt("iconResourceId", iconResourceId);
            numberAnnotation = jsonObject.optInt("numberAnnotation", numberAnnotation);
            cancelOnSelect = jsonObject.optBoolean("cancelOnSelect", cancelOnSelect);
            ongoing = jsonObject.optBoolean("ongoing", ongoing);
            alertPolicy = jsonObject.optString("alertPolicy", alertPolicy);
            hasAction = jsonObject.optBoolean("hasAction", hasAction);
            soundName = jsonObject.optString("soundName", soundName);
            activityClassName = jsonObject.optString("activityClassName", activityClassName);
            priority = jsonObject.optInt("priority", priority);

            long dateTime = jsonObject.optLong("fireDate", fireDate.getTime());

            fireDate = new Date(dateTime);
            repeatInterval = jsonObject.optInt("repeatInterval", repeatInterval);

            try {
                JSONArray jsonArray = jsonObject.getJSONArray("actionData");
                int dataLength = jsonArray.length();
                actionData = new byte[dataLength];
                for (int i = 0; i < dataLength; i++) {
                    actionData[i] = (byte) jsonArray.getInt(i);
                }
            } catch (Exception e) {
                Logger.log("LocalNotification::deserialize Exception while reading actionData");
            }
        }
    }
}

