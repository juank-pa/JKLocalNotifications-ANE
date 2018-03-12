//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.adobe.fre;

import java.util.Map;

public class FREObject {
    protected Object value;

    protected FREObject() {

    }

    protected FREObject(Map<String, FREObject> value) {
        this.value = value;
    }

    protected FREObject(int value) {
        this.value = value;
    }

    protected FREObject(FREObject[] value) {
        this.value = value;
    }

    protected FREObject(double value) {
        this.value = value;
    }

    protected FREObject(boolean value) {
        this.value = value;
    }

    protected FREObject(String value) {
        this.value = value;
    }

    public static FREObject newObject(Map<String, FREObject> value) {
        return new FREObject(value);
    }

    public static FREObject newObject(int value) {
        return new FREObject(value);
    }

    public static FREObject newObject(double value) {
        return new FREObject(value);
    }

    public static FREObject newObject(boolean value) {
        return new FREObject(value);
    }

    public static FREObject newObject(String value) {
        return new FREObject(value);
    }

    public static FREObject newObject(String className, FREObject[] constructorArgs) {
        return new FREObject(className, constructorArgs);
    }

    public int getAsInt() {
        return (int)value;
    }

    public double getAsDouble() {
        return (double)value;
    }

    public boolean getAsBool() {
        return (boolean)value;
    }

    public String getAsString() {
        return (String)value;
    }

    public FREObject(String className, FREObject[] constructorArgs) {

    }

    public FREObject getProperty(String propertyName) {
        if (!((Map<String, FREObject>)value).containsKey(propertyName)) return null;
        return ((Map<String, FREObject>)value).get(propertyName);
    }

    public void setProperty(String propertyName, FREObject propertyValue) {
        ((Map<String, FREObject>)value).put(propertyName, propertyValue);
    }

    public FREObject callMethod(String methodName, FREObject[] methodArgs) {
        return ((Map<String, FREObject>)value).get(methodName);
    }
}
