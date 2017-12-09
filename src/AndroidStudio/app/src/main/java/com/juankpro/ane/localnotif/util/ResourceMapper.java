package com.juankpro.ane.localnotif.util;

import com.adobe.fre.FREContext;

/**
 * Created by Juank on 10/21/17.
 */

public class ResourceMapper {
    public Integer getResourceIdFor(String iconType, FREContext freContext) {
        return freContext.getResourceId("drawable." + iconType);
    }
}
