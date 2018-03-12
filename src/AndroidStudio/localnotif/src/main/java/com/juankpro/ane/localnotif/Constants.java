package com.juankpro.ane.localnotif;

/**
 * Created by Juank on 10/21/17.
 */

public class Constants {
    static final int STANDARD_NOTIFICATION_ID = 0;
    private static final String ANE_NAME = "JK_ANE_LocalNotification";

    public static final String NOTIFICATION_CONFIG = ANE_NAME + "_NOTIF";
    public static final String CATEGORY_CONFIG = ANE_NAME + "_CAT";


    public static final String NOTIFICATION_INTENT_SERVICE = "com.juankpro.ane.localnotif.LocalNotificationIntentService";

    public static final String MAIN_ACTIVITY_CLASS_NAME_KEY = "com.juankpro.ane.localnotif.mainActivityClassNameKey";

    public static final String NOTIFICATION_CODE_KEY = "com.juankpro.ane.localnotif.notificationCodeKey";
    public static final String ACTION_DATA_KEY = "com.juankpro.ane.localnotif.actionDataKey";
    public static final String ACTION_ID_KEY = "NOTIF_ACTION_ID";
    public static final String BACKGROUND_MODE_KEY = "NOTIF_BACKGROUND_MODE";
    public static final String USER_RESPONSE_KEY = "NOTIF_USER_RESPONSE";

    public static final String ICON_RESOURCE = "NOTIF_ICON_RESOURCE";
    public static final String TITLE = "NOTIF_TITLE";
    public static final String BODY = "NOTIF_BODY";
    public static final String NUMBER_ANNOTATION = "NOTIF_NUM_ANNOT";
    public static final String TICKER_TEXT = "NOTIF_TICKER";
    public static final String PLAY_SOUND = "NOTIF_PLAY_SOUND";
    public static final String SOUND_NAME = "NOTIF_SOUND_NAME";
    public static final String VIBRATE = "NOTIF_VIBRATE";
    public static final String CANCEL_ON_SELECT = "NOTIF_CANCEL_OS";
    public static final String ON_GOING = "NOTIF_ONGOING";
    public static final String ALERT_POLICY = "NOTIF_POLICY";
    public static final String HAS_ACTION = "NOTIF_HAS_ACTION";
    public static final String PRIORITY = "NOTIF_PRIORITY";
    public static final String SHOW_IN_FOREGROUND = "NOTIF_SHOW_IN_FOREGROUND";
    public static final String CATEGORY = "NOTIF_CATEGORY";
}
