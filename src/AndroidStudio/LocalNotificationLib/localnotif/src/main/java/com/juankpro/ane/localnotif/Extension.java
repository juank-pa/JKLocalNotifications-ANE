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

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;
import com.juankpro.ane.localnotif.util.Logger;

@SuppressWarnings("unused")
public class Extension implements FREExtension {
    @Override
    public FREContext createContext(String extId) {
        Logger.log("Create Context");
        return LocalNotificationsContext.getInstance();
    }

    @Override
    public void initialize() {
    }

    @Override
    public void dispose() {
    }
}
