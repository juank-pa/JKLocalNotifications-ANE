package com.juankpro.ane.localnotif;

import java.util.HashMap;
import java.util.Map;
import com.adobe.fre.FREContext;

/**
 * Created by Juank on 10/21/17.
 */

class ResourceMapper {
    private static final Map<String, String> resourceMap = createMap();

    private static Map<String, String> createMap() {
        Map<String, String> resourceMap = new HashMap<>();
        resourceMap.put("alert", "drawable.alert_icon");
        resourceMap.put("document", "drawable.document_icon");
        resourceMap.put("error", "drawable.error_icon");
        resourceMap.put("flag", "drawable.flag_icon");
        resourceMap.put("info", "drawable.info_icon");
        resourceMap.put("message", "drawable.message_icon");
        return resourceMap;
    }

    Integer getResourceIdFor(String iconType, FREContext freContext) {
        return freContext.getResourceId(resourceMap.get(iconType));
    }
}
