package com.juankpro.ane.localnotif;

import com.adobe.fre.FREContext;

/**
 * Created by Juank on 10/21/17.
 */

class ResourceMapper {
    Integer getResourceIdFor(String iconType, FREContext freContext) {
        return freContext.getResourceId("drawable." + iconType);
    }
}
