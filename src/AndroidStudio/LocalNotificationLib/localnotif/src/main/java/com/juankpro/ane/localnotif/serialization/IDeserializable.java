package com.juankpro.ane.localnotif.serialization;

import org.json.JSONObject;

/**
 * Created by jpazmino on 11/22/17.
 */

public interface IDeserializable {
    void deserialize(JSONObject jsonObject);
}
