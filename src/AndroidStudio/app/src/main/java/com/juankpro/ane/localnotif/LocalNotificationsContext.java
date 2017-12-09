package com.juankpro.ane.localnotif;

import android.content.Context;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.juankpro.ane.localnotif.category.LocalNotificationCategory;
import com.juankpro.ane.localnotif.category.LocalNotificationCategoryManager;
import com.juankpro.ane.localnotif.decoder.LocalNotificationDecoder;
import com.juankpro.ane.localnotif.decoder.LocalNotificationSettingsDecoder;
import com.juankpro.ane.localnotif.fre.ExtensionUtils;
import com.juankpro.ane.localnotif.fre.FunctionHelper;
import com.juankpro.ane.localnotif.util.ApplicationStatus;
import com.juankpro.ane.localnotif.util.Logger;
import com.juankpro.ane.localnotif.util.PersistenceManager;

/**
 * Created by Juank on 10/21/17.
 */

class LocalNotificationsContext extends FREContext {
    static final private String STATUS = "status";
    static final private String NOTIFICATION_SELECTED = "notificationSelected";
    static final private String SETTINGS_SUBSCRIBED = "settingsSubscribed";

    private static LocalNotificationsContext currentContext;

    static LocalNotificationsContext getInstance() {
        if (currentContext == null) {
            currentContext = new LocalNotificationsContext();
        }
        return currentContext;
    }

    private LocalNotificationManager notificationManager;

    private LocalNotificationManager getManager() {
        if (notificationManager == null) {
            notificationManager = new LocalNotificationManager(getApplicationContext());
        }
        return notificationManager;
    }

    private PersistenceManager persistenceManager;

    private PersistenceManager getPersistenceManager() {
        if (persistenceManager == null) {
            persistenceManager = new PersistenceManager(getApplicationContext());
        }
        return persistenceManager;
    }

    private LocalNotificationCategoryManager categoryManager;

    private LocalNotificationCategoryManager getCategoryManager() {
        if (categoryManager == null) {
            categoryManager = new LocalNotificationCategoryManager(getApplicationContext());
        }
        return categoryManager;
    }

    @Override
    public void dispose() {
        currentContext = null;
    }

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> functionMap = new HashMap<>();

        functionMap.put("checkForNotificationAction", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                checkForNotificationAction();
                return null;
            }
        });

        functionMap.put("getSelectedNotificationCode", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                return getSelectedNotificationCode();
            }
        });

        functionMap.put("getSelectedNotificationData", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                return getSelectedNotificationData();
            }
        });

        functionMap.put("getSelectedNotificationAction", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                return getSelectedNotificationAction();
            }
        });

        functionMap.put("notify", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                sendNotification(context, passedArgs);
                return null;
            }
        });

        functionMap.put("cancel", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                cancel(passedArgs[0].getAsString());
                return null;
            }
        });

        functionMap.put("cancelAll", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                cancelAll();
                return null;
            }
        });

        functionMap.put("activate", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                ApplicationStatus.setInForeground(true);
                return null;
            }
        });

        functionMap.put("deactivate", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                ApplicationStatus.setInForeground(false);
                return null;
            }
        });

        functionMap.put("registerSettings", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                registerSettings(context, passedArgs[0]);
                return null;
            }
        });

        functionMap.put("getSelectedSettings", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                return getSelectedSettings();
            }
        });

        ApplicationStatus.setInForeground(true);
        return functionMap;
    }

    private void registerSettings(final FREContext context, FREObject object) {
        try {
            LocalNotificationSettingsDecoder decoder = new LocalNotificationSettingsDecoder(context);
            LocalNotificationCategory[] categories = decoder.decodeObject(object).categories;
            getCategoryManager().registerCategories(categories);

            dispatchSettingsSubscribed();
        } catch (Throwable e) { e.printStackTrace(); }
    }

    private void dispatchSettingsSubscribed() {
        dispatchStatusEventAsync(SETTINGS_SUBSCRIBED, STATUS);
    }

    void dispatchNotificationSelectedEvent() {
        LocalNotificationCache.getInstance().reset();
        dispatchStatusEventAsync(NOTIFICATION_SELECTED, STATUS);
    }

    private FREObject getSelectedSettings() throws Exception {
        return FREObject.newObject(7);
    }

    private Context getApplicationContext() {
        return getActivity().getApplicationContext();
    }

    private void checkForNotificationAction() {
        if (LocalNotificationCache.getInstance().wasUpdated()) dispatchNotificationSelectedEvent();
        Logger.log("LocalNotificationsContext checking for notification");
    }

    private FREObject getSelectedNotificationCode() throws Exception {
        Logger.log("LocalNotificationsContext::getSelectedNotificationCode code: " + LocalNotificationCache.getInstance().getNotificationCode());
        return FREObject.newObject(LocalNotificationCache.getInstance().getNotificationCode());
    }

    private FREObject getSelectedNotificationData() {
        Logger.log("LocalNotificationsContext::getSelectedNotificationData byte array: " + new String(LocalNotificationCache.getInstance().getNotificationData()));
        return ExtensionUtils.getFreObject(LocalNotificationCache.getInstance().getNotificationData());
    }

    private FREObject getSelectedNotificationAction() throws Exception {
        Logger.log("LocalNotificationsContext::getSelectedNotificationAction action: " + LocalNotificationCache.getInstance().getActionId());
        return FREObject.newObject(LocalNotificationCache.getInstance().getActionId());
    }

    private void sendNotification(FREContext context, FREObject[] passedArgs) {
        LocalNotification localNotification =
                new LocalNotificationDecoder(context, passedArgs[0]).decodeObject(passedArgs[1]);
        getPersistenceManager().writeNotification(localNotification);
        getManager().notify(localNotification);
    }

    private void cancel(String notificationCode) {
        getPersistenceManager().removeNotification(notificationCode);
        getManager().cancel(notificationCode);
    }

    private void cancelAll() {
        getManager().cancelAll();
        getPersistenceManager().clearNotifications();
    }
}

