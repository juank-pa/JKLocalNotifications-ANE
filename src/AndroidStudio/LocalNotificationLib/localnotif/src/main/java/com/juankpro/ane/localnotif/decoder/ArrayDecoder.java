package com.juankpro.ane.localnotif.decoder;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.juankpro.ane.localnotif.util.Logger;

import java.lang.reflect.Array;

/**
 * Created by juank on 11/22/2017.
 */

public class ArrayDecoder<A> extends FREDecoder<A[]> {
    private IDecoder<A> decoder;
    private Class<A> aClass;

    public ArrayDecoder(FREContext context, IDecoder<A> decoder, Class<A> aClass) {
        super(context);
        this.decoder = decoder;
        this.aClass = aClass;
    }

    @SuppressWarnings("unchecked")
    @Override
    protected A[] decode() {
        FREArray freArray = (FREArray)getObject();
        try {
            int length = (int)freArray.getLength();
            A[] array = (A[])Array.newInstance(aClass, length);

            for (int i = 0; i < length; i++) {
                array[i] = decoder.decodeObject(freArray.getObjectAt(i));
            }
            return array;
        } catch (Throwable e) {
            Logger.log("FREDecoder::decodeArray Could not decode array " + e);
        }
        return (A[])Array.newInstance(aClass, 0);
    }
}
