package com.juankpro.ane.localnotif.serialization;

import org.json.JSONArray;

/**
 * Created by jpazmino on 11/22/17.
 */

public class ArraySerializer {
    public JSONArray serialize(ISerializable[] instances) {
        JSONArray array = new JSONArray();
        if (instances == null || instances.length == 0) return array;
        for (ISerializable item : instances) {
            array.put(item.serialize());
        }
        return array;
    }
}
