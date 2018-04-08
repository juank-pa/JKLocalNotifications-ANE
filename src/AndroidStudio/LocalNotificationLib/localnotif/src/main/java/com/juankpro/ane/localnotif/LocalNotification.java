package com.juankpro.ane.localnotif;

import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Notification;
import android.os.Build;

import com.juankpro.ane.localnotif.serialization.IDeserializable;
import com.juankpro.ane.localnotif.serialization.ISerializable;
import com.juankpro.ane.localnotif.util.Logger;

/**
 * Created by Juank on 10/22/17.
 */

public class LocalNotification implements ISerializable, IDeserializable {
    public String code = "";

    // Text.
    public String tickerText = "";
    public String title = "";
    public String body = "";

    public boolean isExact = false;
    public boolean allowWhileIdle = false;

    // Sound.
    public boolean playSound = false;

    // Vibration.
    public boolean vibrate = false;

    // Icon.
    public int iconResourceId = 0;
    public int numberAnnotation = 0;

    // Miscellaneous.
    public boolean cancelOnSelect = false;
    public boolean ongoing = false;
    public String alertPolicy = "";

    public String soundName = "";

    // Action.
    public boolean hasAction = true;
    public byte[] actionData = {};

    public Date fireDate = new Date();
    public int repeatInterval = 0;

    public int priority = Notification.PRIORITY_DEFAULT;

    public  boolean showInForeground = false;

    public String activityClassName = "";
    public String category = "";

    @SuppressWarnings("WeakerAccess")
    public long getRepeatIntervalMilliseconds() {
        return new LocalNotificationTimeInterval(repeatInterval)
                .toMilliseconds();
    }

    public boolean repeatsRecurrently() {
        return (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT || isExact) && repeatInterval != 0;
    }

    public LocalNotification() {
        this(null);
    }

    public LocalNotification(String activityClassName) {
        this.activityClassName = activityClassName;
    }

    public JSONObject serialize() {
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
            jsonObject.putOpt("showInForeground", showInForeground);
            jsonObject.putOpt("category", category);
            jsonObject.putOpt("isExact", isExact);
            jsonObject.putOpt("allowWhileIdle", allowWhileIdle);

            for (byte anActionData : actionData) {
                jsonObject.accumulate("actionData", (int)anActionData);
            }
        }
        catch (Exception e) {
            Logger.log("LocalNotification::serialize Exception");
        }
        return jsonObject;
    }


    public void deserialize(JSONObject jsonObject) {
        if (jsonObject != null) {
            code = jsonObject.optString("code", code);
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
            showInForeground = jsonObject.optBoolean("showInForeground", showInForeground);
            category = jsonObject.optString("category", category);
            isExact = jsonObject.optBoolean("isExact", isExact);
            allowWhileIdle = jsonObject.optBoolean("allowWhileIdle", allowWhileIdle);

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

