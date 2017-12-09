package com.juankpro.ane.localnotif.category;

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

    public JSONObject serialize() {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.putOpt("identifier", identifier);
            jsonObject.putOpt("title", title);
            jsonObject.putOpt("icon", icon);
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
        }
    }
}
