package com.adobe.fre;

import java.nio.ByteBuffer;

public class FREByteArray extends FREObject {
    byte bytes[];
    int length = 0;

    protected FREByteArray() {
        super("flash.utils.ByteArray", null);
        this.bytes = new byte[500];
        length = 0;
    }

    protected FREByteArray(byte[] bytes) {
        super("flash.utils.ByteArray", null);
        this.bytes = bytes;
        length = bytes.length;
    }

    public static FREByteArray newByteArray() {
        return new FREByteArray();
    }

    public static FREByteArray newByteArray(byte[] bytes) {
        return new FREByteArray(bytes);
    }

    public long getLength() {
        return length;
    }

    public ByteBuffer getBytes() {
        return ByteBuffer.wrap(bytes, 0, length);
    }

    public void writeByte(byte value) {
        bytes[length] = value;
        length++;
    }

    public void acquire() { }

    public void release() { }
}
