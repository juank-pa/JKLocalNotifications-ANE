package com.juankpro.ane.testapplication;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.juankpro.ane.localnotif.Extension;
import com.juankpro.ane.localnotif.LocalNotificationCache;
import com.juankpro.ane.localnotif.LocalNotificationsContext;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class MainActivity extends Activity {
    private FREContext context;
    private Map<String, FREFunction> functions;
    private TextView textView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        textView = (TextView) findViewById(R.id.resultsTextView);

        context = new Extension().createContext("warningIcon");
        context.setActivity(this);
        functions = context.getFunctions();
    }

    public void onResume() {
        super.onResume();

        callFunction("checkForNotificationAction");

        if (context.getSavedEventCode() != null) {
            if(context.getSavedEventCode().equals(LocalNotificationsContext.NOTIFICATION_SELECTED))
                didReceiveNotification();
            context.reset();
        }
    }

    private void callFunction(String name, FREObject... params) {
        functions.get(name).call(context, params);
    }

    private FREObject getFREObject(String value) {
        return FREObject.newObject(value);
    }

    private FREObject getFREObject(boolean value) {
        return FREObject.newObject(value);
    }

    private FREObject getFREObject(int value) {
        return FREObject.newObject(value);
    }

    private FREObject getFREObject(double value) {
        return FREObject.newObject(value);
    }

    private FREObject getFREObject(Map<String, FREObject> value) {
        return FREObject.newObject(value);
    }

    private FREArray getFREArray(FREObject... value) {
        return FREArray.newArray(value);
    }

    private FREObject createNotification() {
        try {
            Map<String, FREObject> notification = new HashMap<>();
            notification.put("fireDate", createDate());
            notification.put("playSound", getFREObject(true));
            notification.put("soundName", getFREObject(""));
            notification.put("title", getFREObject("Title"));
            notification.put("body", getFREObject("Hello"));
            notification.put("iconType", getFREObject("icon"));
            notification.put("numberAnnotation", getFREObject(2));
            notification.put("cancelOnSelect", getFREObject(true));
            //notification.put("notification.repeatInterval", getFREObject(LocalNotificationTimeInterval.MINUTE_CALENDAR_UNIT));
            notification.put("showInForeground", getFREObject(true));
            notification.put("category", getFREObject("CategoryX"));
            return getFREObject(notification);
        }
        catch(Throwable e) {}
        return null;
    }

    private FREObject createSettings() {
        try {
            Map<String, FREObject> notification = new HashMap<>();
            notification.put("categories", createCategories());
            return getFREObject(notification);
        }
        catch(Throwable e) {}
        return null;
    }

    private FREArray createCategories() {
        try {
            Map<String, FREObject> notification = new HashMap<>();
            notification.put("identifier", getFREObject("CategoryX"));
            notification.put("actions", createActions());
            return getFREArray(FREObject.newObject(notification));
        }
        catch(Throwable e) {}
        return null;
    }

    private FREArray createActions() {
        try {
            Map<String, FREObject> action1 = new HashMap<>();
            action1.put("identifier", getFREObject("okAction"));
            action1.put("title", getFREObject("OK"));
            action1.put("icon", getFREObject("okIcon"));
            action1.put("isBackground", getFREObject(false));

            Map<String, FREObject> action2 = new HashMap<>();
            action2.put("identifier", getFREObject("cancelAction"));
            action2.put("title", getFREObject("Cancel"));
            action2.put("icon", getFREObject("cancelIcon"));
            action2.put("isBackground", getFREObject(true));
            action2.put("textInputPlaceholder", getFREObject("What's up..."));
            action2.put("textInputButtonTitle", getFREObject("Fight!"));

            Map<String, FREObject> action3 = new HashMap<>();
            action3.put("identifier", getFREObject("testAction"));
            action3.put("title", getFREObject("Test"));
            action3.put("icon", getFREObject("testIcon"));
            action3.put("isBackground", getFREObject(false));

            return getFREArray(FREObject.newObject(action1), FREObject.newObject(action2), FREObject.newObject(action3));
        }
        catch(Throwable e) {}
        return null;
    }

    private FREObject createDate() {
        try {
            Map<String, FREObject> date = new HashMap<>();
            date.put("time", getFREObject((double)new Date().getTime() + 5000));
            return getFREObject(date);
        }
        catch(Throwable e) {}
        return null;
    }

    public void onClear(View view) {
        textView.setText("");
    }

    public void onPost(View view) {
        callFunction("notify", getFREObject("JKCode"), createNotification());
    }

    public void onCancel(View view) {
        callFunction("cancel", getFREObject("JKCode"));
    }

    public void onCancelAll(View view) {
        callFunction("cancelAll");
    }

    private void printMessage(String message, String title) {
        String formattedMessage = getMessage(message, title);

        textView.setText(formattedMessage);
        textView.scrollTo(0, textView.getScrollY());
    }

    private String getMessage(String message, String title) {
        String newTitle = title.length() != 0? title + "\n" : title;
        return String.format("%s-----\n%s%s\n", textView.getText(), newTitle, message);
    }

    public void didReceiveNotification() {
        String string = String.format("%s\n%s\n%s",
                LocalNotificationCache.getInstance().getNotificationCode(),
                LocalNotificationCache.getInstance().getActionId(),
                LocalNotificationCache.getInstance().getUserResponse());
        printMessage(string, "Local Notification");
    }
}
