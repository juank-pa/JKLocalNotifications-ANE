package com.juankpro.ane.localnotif.category;

import android.os.Build;

import com.juankpro.ane.localnotif.util.Logger;
import com.juankpro.ane.localnotif.serialization.IDeserializable;
import com.juankpro.ane.localnotif.serialization.ISerializable;

import org.json.JSONObject;

/**
 * Created by jpazmino on 11/22/17.
 */

public class LocalNotificationAction implements IDeserializable, ISerializable {
    public String identifier = "";
    public String title = "";
    public int icon = 0;
    public boolean isBackground = false;
    public String textInputPlaceholder;

    public boolean isTextInput() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.N &&
                textInputPlaceholder != null &&
                !textInputPlaceholder.isEmpty();
    }

    public JSONObject serialize() {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.putOpt("identifier", identifier);
            jsonObject.putOpt("title", title);
            jsonObject.putOpt("icon", icon);
            jsonObject.putOpt("isBackground", isBackground);
            jsonObject.putOpt("textInputPlaceholder", textInputPlaceholder);
        } catch (Exception e) {
            Logger.log("LocalNotification::serialize Exception");
        }
        return jsonObject;
    }

    public void deserialize(JSONObject jsonObject) {
        if (jsonObject != null) {
            this.identifier = jsonObject.optString("identifier", "");
            this.title = jsonObject.optString("title", "");
            this.icon = jsonObject.optInt("icon", 0);
            this.isBackground = jsonObject.optBoolean("isBackground", false);
            this.textInputPlaceholder = jsonObject.optString("textInputPlaceholder");
        }
    }
}
