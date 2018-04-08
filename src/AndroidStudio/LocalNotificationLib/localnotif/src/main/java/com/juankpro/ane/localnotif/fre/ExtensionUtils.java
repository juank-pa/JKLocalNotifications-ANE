/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2011 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/

package com.juankpro.ane.localnotif.fre;

import java.lang.reflect.Array;
import java.nio.ByteBuffer;
import java.util.Date;

import com.adobe.fre.FREByteArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FRENoSuchNameException;
import com.adobe.fre.FREObject;
import com.juankpro.ane.localnotif.decoder.ArrayDecoder;
import com.juankpro.ane.localnotif.decoder.IDecoder;
import com.juankpro.ane.localnotif.util.Logger;

@SuppressWarnings("SameParameterValue")
public class ExtensionUtils {
    /**
     * Helper method for getting a String property from a FREObject.
     *
     * @param freObject    The object you want to get the property from.
     * @param propertyName The exact name of the property you want to get.
     * @param defaultValue This will be returned if the specified propertyName does not exist or is null in the supplied freObject.
     * @return The String value of the specified property if it exists or is not null, otherwise defaultValue will be returned.
     */
    public static String getStringProperty(FREObject freObject, String propertyName, String defaultValue) {
        try {
            FREObject propertyObject = freObject.getProperty(propertyName);
            if (propertyObject != null) return propertyObject.getAsString();
        }
        catch (FRENoSuchNameException e) { Logger.log("Property not found: " + propertyName); }
        catch (Throwable e) { e.printStackTrace(); }

        return defaultValue;
    }

    /**
     * Helper method for getting a Boolean property from a FREObject.
     *
     * @param freObject    The object you want to get the property from.
     * @param propertyName The exact name of the property you want to get.
     * @param defaultValue This will be returned if the specified propertyName does not exist or is null in the supplied freObject.
     * @return The Boolean value of the specified property if it exists or is not null, otherwise defaultValue will be returned.
     */
    public static boolean getBooleanProperty(FREObject freObject, String propertyName, boolean defaultValue) {
        try {
            FREObject propertyObject = freObject.getProperty(propertyName);
            if (propertyObject != null) return propertyObject.getAsBool();
        }
        catch (FRENoSuchNameException e) { Logger.log("Property not found: " + propertyName); }
        catch (Throwable e) { e.printStackTrace(); }

        return defaultValue;
    }

    /**
     * Helper method for getting an int property from a FREObject.
     *
     * @param freObject    The object you want to get the property from.
     * @param propertyName The exact name of the property you want to get.
     * @param defaultValue This will be returned if the specified propertyName does not exist or is null in the supplied freObject.
     * @return The int value of the specified property if it exists or is not null, otherwise defaultValue will be returned.
     */
    public static int getIntProperty(FREObject freObject, String propertyName, int defaultValue) {
        try {
            FREObject propertyObject = freObject.getProperty(propertyName);
            if (propertyObject != null) return propertyObject.getAsInt();
        }
        catch (FRENoSuchNameException e) { Logger.log("Property not found: " + propertyName); }
        catch (Throwable e) { e.printStackTrace(); }

        return defaultValue;
    }

    /**
     * Helper method for getting an int property from a FREObject.
     *
     * @param freObject    The object you want to get the property from.
     * @param propertyName The exact name of the property you want to get.
     * @param defaultValue This will be returned if the specified propertyName does not exist or is null in the supplied freObject.
     * @return The int value of the specified property if it exists or is not null, otherwise defaultValue will be returned.
     */
    @SuppressWarnings("WeakerAccess")
    public static double getDoubleProperty(FREObject freObject, String propertyName, double defaultValue) {
        try {
            FREObject propertyObject = freObject.getProperty(propertyName);
            if (propertyObject != null) return propertyObject.getAsDouble();
        }
        catch (FRENoSuchNameException e) { Logger.log("Property not found: " + propertyName); }
        catch (Throwable e) { e.printStackTrace(); }

        return defaultValue;
    }

    /**
     * Helper method for getting an int property from a FREObject.
     *
     * @param freObject    The object you want to get the property from.
     * @param propertyName The exact name of the property you want to get.
     * @param defaultValue This will be returned if the specified propertyName does not exist or is null in the supplied freObject.
     * @return The int value of the specified property if it exists or is not null, otherwise defaultValue will be returned.
     */
    public static Date getDateProperty(FREObject freObject, String propertyName, Date defaultValue) {
        try {
            FREObject propertyObject = freObject.getProperty(propertyName);
            if (propertyObject != null) {
                double timestamp = getDoubleProperty(propertyObject, "time", 0.0);
                if (timestamp > 0) return new Date((long) timestamp);
            }
        }
        catch (FRENoSuchNameException e) { Logger.log("Property not found: " + propertyName); }
        catch (Throwable e) { e.printStackTrace(); }

        return defaultValue == null? new Date() : defaultValue;
    }

    public static byte[] getBytesProperty(FREObject freObject, String propertyName, byte[] defaultValue) {
        FREByteArray byteArray = null;

        try {
            byteArray = (FREByteArray) freObject.getProperty(propertyName);
            if (byteArray != null) {
                byteArray.acquire();
                ByteBuffer byteBuffer = byteArray.getBytes();
                byteArray.release();

                byte[] value = new byte[byteBuffer.limit()];
                byteBuffer.get(value);
                return value;
            }
        }
        catch (FRENoSuchNameException e) { Logger.log("Property not found: " + propertyName); }
        catch (Throwable e) {
            e.printStackTrace();
            try { if (byteArray != null) byteArray.release(); }
            catch(Throwable ei) { ei.printStackTrace(); }
        }

        return defaultValue;
    }

    public static FREObject getFreObject(byte[] data) {
        try {
            FREObject byteArray = FREObject.newObject("flash.utils.ByteArray", null);
            for (byte aByte : data) {
                FREObject arguments[] = new FREObject[] { FREObject.newObject(aByte) };
                byteArray.callMethod("writeByte", arguments);
            }
            return byteArray;
        } catch (Throwable e) { e.printStackTrace(); }

        return null;
    }

    public static <D> D[] getArrayProperty(FREContext freContext, FREObject freObject, String propertyName, IDecoder<D> decoder, Class<D> aClass) {
        try {
            FREObject propertyObject = freObject.getProperty(propertyName);
            ArrayDecoder<D> arrayDecoder = new ArrayDecoder<>(freContext, decoder, aClass);
            return arrayDecoder.decodeObject(propertyObject);
        }
        catch (FRENoSuchNameException e) { Logger.log("Property not found: " + propertyName); }
        catch (Throwable e) {
            e.printStackTrace();
        }
        return (D[])Array.newInstance(aClass, 0);
    }

}

