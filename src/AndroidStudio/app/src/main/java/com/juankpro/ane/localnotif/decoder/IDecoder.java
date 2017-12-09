package com.juankpro.ane.localnotif.decoder;

import com.adobe.fre.FREObject;

/**
 * Created by juank on 11/22/2017.
 */

public interface IDecoder<T> {
    T decodeObject(FREObject passedObj);
}
