package com.juankpro.ane.localnotif.category;

import com.juankpro.ane.localnotif.util.Logger;
import com.juankpro.ane.localnotif.serialization.ArrayDeserializer;
import com.juankpro.ane.localnotif.serialization.ArraySerializer;
import com.juankpro.ane.localnotif.serialization.IDeserializable;
import com.juankpro.ane.localnotif.serialization.ISerializable;

import org.json.JSONObject;

/**
 * Created by jpazmino on 11/22/17.
 */

public class LocalNotificationCategory implements ISerializable, IDeserializable {
    public String identifier = "";
    public LocalNotificationAction[] actions;
    public boolean useCustomDismissAction;

    public JSONObject serialize() {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.putOpt("identifier", identifier);
            jsonObject.putOpt("useCustomDismissAction", useCustomDismissAction);
            jsonObject.putOpt("actions", new ArraySerializer().serialize(actions));
        } catch (Exception e) {
            Logger.log("LocalNotification::serialize Exception");
        }
        return jsonObject;
    }

    public void deserialize(JSONObject jsonObject) {
        if (jsonObject != null) {
            try {
                identifier = jsonObject.optString("identifier", "");
                useCustomDismissAction = jsonObject.optBoolean("useCustomDismissAction");
                actions = new ArrayDeserializer<>(LocalNotificationAction.class)
                        .deserialize(jsonObject.getJSONArray("actions"));
            } catch (Exception e) {
                Logger.log("LocalNotification::deserialize Exception");
            }
        }
    }
}
