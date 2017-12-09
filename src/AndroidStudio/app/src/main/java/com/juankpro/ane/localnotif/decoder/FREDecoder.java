package com.juankpro.ane.localnotif.decoder;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.juankpro.ane.localnotif.category.LocalNotificationAction;
import com.juankpro.ane.localnotif.fre.ExtensionUtils;
import com.juankpro.ane.localnotif.util.ResourceMapper;

import java.util.Date;

/**
 * Created by juank on 11/22/2017.
 */

@SuppressWarnings({"WeakerAccess", "SameParameterValue"})
abstract class FREDecoder<T> implements IDecoder<T> {
    private FREObject freObject;
    private FREContext freContext;

    FREDecoder(FREContext context) {
        this.freContext = context;
    }

    public T decodeObject(FREObject passedObj) {
        this.freObject = passedObj;
        return decode();
    }

    abstract protected T decode();

    protected FREContext getContext() {
        return freContext;
    }

    protected FREObject getObject() {
        return freObject;
    }

    protected Date decodeDate(String propertyName, Date defaultValue) {
        return ExtensionUtils.getDateProperty(freObject, propertyName, defaultValue);
    }

    protected int decodeInt(String propertyName, int defaultValue) {
        return ExtensionUtils.getIntProperty(freObject, propertyName, defaultValue);
    }

    protected String decodeString(String propertyName, String defaultValue) {
        return ExtensionUtils.getStringProperty(freObject, propertyName, defaultValue);
    }

    protected boolean decodeBoolean(String propertyName, boolean defaultValue) {
        return ExtensionUtils.getBooleanProperty(freObject, propertyName, defaultValue);
    }

    protected byte[] decodeBytes(String propertyName, byte[] defaultValue) {
        return ExtensionUtils.getBytesProperty(freObject, propertyName, defaultValue);
    }

    protected int decodeResourceId(String propertyName) {
        String iconType = decodeString(propertyName, "");
        if (freContext == null) { return 0; }
        return new ResourceMapper().getResourceIdFor(iconType, freContext);
    }

    protected <D> D[] decodeArray(String propertyName, IDecoder<D> decoder, Class<D> aClass) {
        return ExtensionUtils.getArrayProperty(freContext, freObject, propertyName, decoder, aClass);
    }
}
