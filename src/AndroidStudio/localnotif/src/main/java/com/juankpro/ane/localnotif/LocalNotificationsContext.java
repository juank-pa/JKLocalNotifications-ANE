package com.juankpro.ane.localnotif;

import android.content.Context;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.juankpro.ane.localnotif.category.LocalNotificationCategory;
import com.juankpro.ane.localnotif.category.LocalNotificationCategoryManager;
import com.juankpro.ane.localnotif.decoder.LocalNotificationCategoryDecoder;
import com.juankpro.ane.localnotif.decoder.LocalNotificationDecoder;
import com.juankpro.ane.localnotif.decoder.LocalNotificationSettingsDecoder;
import com.juankpro.ane.localnotif.fre.ExtensionUtils;
import com.juankpro.ane.localnotif.fre.FunctionHelper;
import com.juankpro.ane.localnotif.util.PersistenceManager;

/**
 * Created by Juank on 10/21/17.
 */

public class LocalNotificationsContext extends FREContext {
    static final private String STATUS = "status";
    static final public String NOTIFICATION_SELECTED = "notificationSelected";
    static final public String SETTINGS_SUBSCRIBED = "settingsSubscribed";

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

        functionMap.put("getSelectedNotificationUserResponse", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                return getSelectedNotificationUserResponse();
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

        functionMap.put("registerDefaultCategory", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                registerDefaultCategory(context, passedArgs[0]);
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

        return functionMap;
    }

    private void registerDefaultCategory(final FREContext context, FREObject object) {
        LocalNotificationCategoryDecoder decoder = new LocalNotificationCategoryDecoder(context);
        LocalNotificationCategory[] categories = new LocalNotificationCategory[]{ decoder.decodeObject(object) };
        getCategoryManager().registerCategories(categories);
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
    }

    private FREObject getSelectedNotificationCode() throws Exception {
        return FREObject.newObject(LocalNotificationCache.getInstance().getNotificationCode());
    }

    private FREObject getSelectedNotificationData() {
        return ExtensionUtils.getFreObject(LocalNotificationCache.getInstance().getNotificationData());
    }

    private FREObject getSelectedNotificationAction() throws Exception {
        return FREObject.newObject(LocalNotificationCache.getInstance().getActionId());
    }

    private FREObject getSelectedNotificationUserResponse() throws Exception {
        return FREObject.newObject(LocalNotificationCache.getInstance().getUserResponse());
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

