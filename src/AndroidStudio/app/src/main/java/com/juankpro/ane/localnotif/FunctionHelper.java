package com.juankpro.ane.localnotif;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

/**
 * Created by Juank on 10/22/17.
 */

abstract class FunctionHelper implements FREFunction {
    public abstract FREObject invoke(FREContext context, FREObject[] passedArgs) throws Throwable;

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        FREObject result = null;

        try {
            result = invoke(context, passedArgs);
        } catch (Throwable e) {
            e.printStackTrace();
            Logger.error("Unhandled exception" + e.toString());
            try {
                result = FREObject.newObject("Exception! " + e);
            } catch (FREWrongThreadException wte) {
                wte.printStackTrace();
            }
        }
        return result;
    }
}
