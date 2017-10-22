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


package com.juankpro.ane.localnotif;


import java.util.Date;

import com.adobe.fre.FREObject;


class ExtensionUtils {
    /**
     * Helper method for getting a String property from a FREObject.
     *
     * @param freObject    The object you want to get the property from.
     * @param propertyName The exact name of the property you want to get.
     * @param defaultValue This will be returned if the specified propertyName does not exist or is null in the supplied freObject.
     * @return The String value of the specified property if it exists or is not null, otherwise defaultValue will be returned.
     */
    static String getStringProperty(FREObject freObject, String propertyName, String defaultValue) {
        String property = defaultValue;

        FREObject propertyObject;

        try {
            propertyObject = freObject.getProperty(propertyName);
            if (propertyObject != null) {
                property = propertyObject.getAsString();
            }
        } catch (Throwable e) {
            // Do nothing, the property will remain as the specified default.
        }

        return property;
    }

    /**
     * Helper method for getting a Boolean property from a FREObject.
     *
     * @param freObject    The object you want to get the property from.
     * @param propertyName The exact name of the property you want to get.
     * @param defaultValue This will be returned if the specified propertyName does not exist or is null in the supplied freObject.
     * @return The Boolean value of the specified property if it exists or is not null, otherwise defaultValue will be returned.
     */
    static boolean getBooleanProperty(FREObject freObject, String propertyName, boolean defaultValue) {
        boolean property = defaultValue;

        FREObject propertyObject;

        try {
            propertyObject = freObject.getProperty(propertyName);
            if (propertyObject != null) {
                property = propertyObject.getAsBool();
            }
        } catch (Throwable e) {
            // Do nothing, the property will remain as the specified default.
        }

        return property;
    }

    /**
     * Helper method for getting an int property from a FREObject.
     *
     * @param freObject    The object you want to get the property from.
     * @param propertyName The exact name of the property you want to get.
     * @param defaultValue This will be returned if the specified propertyName does not exist or is null in the supplied freObject.
     * @return The int value of the specified property if it exists or is not null, otherwise defaultValue will be returned.
     */
    static int getIntProperty(FREObject freObject, String propertyName, int defaultValue) {
        int property = defaultValue;

        FREObject propertyObject;

        try {
            propertyObject = freObject.getProperty(propertyName);
            if (propertyObject != null) {
                property = propertyObject.getAsInt();
            }
        } catch (Throwable e) {
            // Do nothing, the property will remain as the specified default.
        }

        return property;
    }

    /**
     * Helper method for getting an int property from a FREObject.
     *
     * @param freObject    The object you want to get the property from.
     * @param propertyName The exact name of the property you want to get.
     * @param defaultValue This will be returned if the specified propertyName does not exist or is null in the supplied freObject.
     * @return The int value of the specified property if it exists or is not null, otherwise defaultValue will be returned.
     */
    static double getDoubleProperty(FREObject freObject, String propertyName, double defaultValue) {
        double property = defaultValue;

        FREObject propertyObject;

        try {
            propertyObject = freObject.getProperty(propertyName);
            if (propertyObject != null) {
                property = propertyObject.getAsDouble();
            }
        } catch (Throwable e) {
            // Do nothing, the property will remain as the specified default.
        }

        return property;
    }

    /**
     * Helper method for getting an int property from a FREObject.
     *
     * @param freObject    The object you want to get the property from.
     * @param propertyName The exact name of the property you want to get.
     * @param defaultValue This will be returned if the specified propertyName does not exist or is null in the supplied freObject.
     * @return The int value of the specified property if it exists or is not null, otherwise defaultValue will be returned.
     */
    static Date getDateProperty(FREObject freObject, String propertyName, Date defaultValue) {
        Date property = defaultValue;

        if (property == null) property = new Date();

        FREObject propertyObject;

        try {
            propertyObject = freObject.getProperty(propertyName);
            if (propertyObject != null) {
                double timestamp = getDoubleProperty(propertyObject, "time", 0.0);

                if (timestamp > 0) {
                    property.setTime((long) timestamp);
                }
            }
        } catch (Throwable e) {
            // Do nothing, the property will remain as the specified default.
        }

        return property;
    }
}

