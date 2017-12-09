package com.juankpro.ane.localnotif;

import com.juankpro.ane.localnotif.serialization.IDeserializable;

import org.json.JSONObject;

/**
 * Created by juank on 11/23/2017.
 */

public class DeserializableTest implements IDeserializable {
    boolean deserialized = false;
    @Override
    public void deserialize(JSONObject jsonObject) {
        deserialized = true;
    }
}
