package com.juankpro.ane.localnotif;

import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREByteArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

/**
 * Created by Juank on 10/21/17.
 */


class LocalNotificationsContext extends FREContext {
    static final private String STATUS = "status";
    static final private String NOTIFICATION_SELECTED = "notificationSelected";

    private static LocalNotificationsContext currentContext;

    static LocalNotificationsContext getInstance() {
        if(currentContext == null) {
            Logger.log("LocalNotificationsContext instantiating!");
            currentContext = new LocalNotificationsContext();
        }
        return currentContext;
    }

    private LocalNotificationManager notificationManager;

    private LocalNotificationsContext() {
        Logger.log("LocalNotificationsContext cache instance");
    }

    private LocalNotificationManager getManager() {
        if (notificationManager == null) {
            notificationManager = new LocalNotificationManager(getActivity());
        }
        return notificationManager;
    }

    @Override
    public void dispose() {
        currentContext = null;
        Logger.log("LocalNotificationsContext::dispose set instance to null");
    }

    @Override
    public Map<String, FREFunction> getFunctions() {
        Logger.log("LocalNotificationsContext registering functions");

        Map<String, FREFunction> functionMap = new HashMap<>();

        functionMap.put("checkForNotificationAction", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                Logger.log("LocalNotificationsContext checking for notification");
                if (LocalNotificationCache.getInstance().wasUpdated()) {
                    dispatchNotificationSelectedEvent();
                }

                return null;
            }
        });

        functionMap.put("getSelectedNotificationCode", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                Logger.log("LocalNotificationsContext::getSelectedNotificationCode code: " + LocalNotificationCache.getInstance().getNotificationCode());
                return FREObject.newObject(LocalNotificationCache.getInstance().getNotificationCode());
            }
        });

        functionMap.put("getSelectedNotificationData", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                FREObject byteArray = FREObject.newObject("flash.utils.ByteArray", null);

                byte[] data = LocalNotificationCache.getInstance().getNotificationData();

                // Construct an ActionScript ByteArray object containing the action data of the selected notification.
                for (byte aByte : data) {
                    FREObject arguments[] = new FREObject[1];
                    arguments[0] = FREObject.newObject(aByte);
                    byteArray.callMethod("writeByte", arguments);
                }

                Logger.log("LocalNotificationsContext::getSelectedNotificationData byte array: " + new String(LocalNotificationCache.getInstance().getNotificationData()));
                return byteArray;
            }
        });

        functionMap.put("notify", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                LocalNotification localNotification = decodeLocalNotification(passedArgs[0].getAsString(), passedArgs[1], context);
                getManager().persistNotification(localNotification);
                // Fire the notification from the specified manager.
                getManager().notify(localNotification);
                return null;
            }
        });

        functionMap.put("cancel", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                String notificationCode = passedArgs[0].getAsString();
                getManager().unpersistNotification(notificationCode);
                getManager().cancel(notificationCode);
                return null;
            }
        });

        functionMap.put("cancelAll", new FunctionHelper() {
            @Override
            public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Exception {
                getManager().cancelAll();
                getManager().unpersistAllNotifications();
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

        ApplicationStatus.setInForeground(true);
        return functionMap;
    }

    private static LocalNotification decodeLocalNotification(String code, FREObject freObject, FREContext freContext) throws Exception {
        // Get the activity class name and pass it to the notification.
        String activityClassName = freContext.getActivity().getClass().getName();
        Logger.log("LocalNotificationsContext::decodeLocalNotification Activity Class Name: " + activityClassName);

        LocalNotification localNotification = new LocalNotification(activityClassName);

        // Notification Name.
        localNotification.code = code;

        // IMPORTANT: These property names must match the names in the Notification ActionScript class exactly.
        localNotification.fireDate = ExtensionUtils.getDateProperty(freObject, "fireDate", localNotification.fireDate);
        localNotification.repeatInterval = ExtensionUtils.getIntProperty(freObject, "repeatInterval", localNotification.repeatInterval);

        // Text.
        localNotification.tickerText = ExtensionUtils.getStringProperty(freObject, "tickerText", localNotification.tickerText);
        localNotification.title = ExtensionUtils.getStringProperty(freObject, "title", localNotification.title);
        localNotification.body = ExtensionUtils.getStringProperty(freObject, "body", localNotification.body);

        // Sound.
        localNotification.playSound = ExtensionUtils.getBooleanProperty(freObject, "playSound", localNotification.playSound);
        localNotification.soundName = ExtensionUtils.getStringProperty(freObject, "soundName", localNotification.soundName);

        // Vibration.
        localNotification.vibrate = ExtensionUtils.getBooleanProperty(freObject, "vibrate", localNotification.vibrate);

        // Icon.
        String iconType = ExtensionUtils.getStringProperty(freObject, "iconType", "");
        localNotification.iconResourceId = getIconResourceIdFromString(iconType, freContext);
        localNotification.numberAnnotation = ExtensionUtils.getIntProperty(freObject, "numberAnnotation", localNotification.numberAnnotation);

        // Action.
        localNotification.hasAction = ExtensionUtils.getBooleanProperty(freObject, "hasAction", localNotification.hasAction);

        // Miscellaneous.
        localNotification.cancelOnSelect = ExtensionUtils.getBooleanProperty(freObject, "cancelOnSelect", localNotification.cancelOnSelect);
        localNotification.repeatAlertUntilAcknowledged = ExtensionUtils.getBooleanProperty(freObject, "repeatAlertUntilAcknowledged", localNotification.repeatAlertUntilAcknowledged);
        localNotification.alertPolicy = ExtensionUtils.getStringProperty(freObject, "alertPolicy", localNotification.alertPolicy);
        localNotification.ongoing = ExtensionUtils.getBooleanProperty(freObject, "ongoing", localNotification.ongoing);

        // Action data.
        FREByteArray byteArray = (FREByteArray) freObject.getProperty("actionData");
        if (byteArray != null) {
            byteArray.acquire();
            ByteBuffer byteBuffer = byteArray.getBytes();
            byteArray.release();

            localNotification.actionData = new byte[byteBuffer.limit()];
            byteBuffer.get(localNotification.actionData);
        } else {
            localNotification.actionData = new byte[0];
        }

        return localNotification;
    }

    void dispatchNotificationSelectedEvent() {
        LocalNotificationCache.getInstance().reset();
        dispatchStatusEventAsync(NOTIFICATION_SELECTED, STATUS);
    }

    private static int getIconResourceIdFromString(String iconType, FREContext freContext) {
        if (freContext == null) { return 0; }
        return new ResourceMapper().getResourceIdFor(iconType, freContext);
    }
}

