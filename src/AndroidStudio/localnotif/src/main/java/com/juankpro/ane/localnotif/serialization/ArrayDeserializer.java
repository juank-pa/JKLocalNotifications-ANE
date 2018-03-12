package com.juankpro.ane.localnotif.serialization;

import org.json.JSONArray;
import org.json.JSONObject;

import java.lang.reflect.Array;

/**
 * Created by jpazmino on 11/22/17.
 */

public class ArrayDeserializer<T extends IDeserializable> {
    private Class<T> aClass;

    public ArrayDeserializer(Class<T> aClass) {
        this.aClass = aClass;
    }

    @SuppressWarnings("unchecked")
    public T[] deserialize(JSONArray objects) throws Exception {
        T[] items;

        try {
            items = (T[]) Array.newInstance(aClass, objects.length());

            for (int i = 0; i < objects.length(); i++) {
                JSONObject actionObject = objects.getJSONObject(i);
                T instance = aClass.newInstance();
                instance.deserialize(actionObject);
                items[i] = instance;
            }
        }
        catch (Throwable e) {
            items = null;
        }

        return items == null? (T[]) Array.newInstance(aClass, 0) : items;
    }
}
