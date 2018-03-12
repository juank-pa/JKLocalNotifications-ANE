//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.adobe.fre;

public class FREArray extends FREObject {
    public FREArray(FREObject[] value) {
        super(value);
    }

    public static FREArray newArray(FREObject[] value) {
        return new FREArray(value);
    }

    public long getLength() {
        return ((FREObject[])value).length;
    }

    public void setLength(long var1) {
    }

    public FREObject getObjectAt(long var1) {
        return ((FREObject[])value)[(int)var1];
    }

    public void setObjectAt(long var1, FREObject var3) {
        ((FREObject[])value)[(int)var1] = var3;
    }
}