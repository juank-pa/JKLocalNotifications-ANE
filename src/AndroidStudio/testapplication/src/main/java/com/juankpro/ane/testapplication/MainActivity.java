package com.juankpro.ane.testapplication;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.os.Bundle;
import android.text.method.ScrollingMovementMethod;
import android.view.View;
import android.widget.TextView;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREByteArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.juankpro.ane.localnotif.Extension;
import com.juankpro.ane.localnotif.LocalNotificationTimeInterval;

import java.nio.charset.Charset;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@SuppressLint("DefaultLocale")
public class MainActivity extends Activity {
    private FREContext context;
    private Map<String, FREFunction> functions;
    private TextView textView;
    private String cat = "CategoryX";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        textView = (TextView)findViewById(R.id.resultsTextView);
        textView.setMovementMethod(new ScrollingMovementMethod());

        context = new Extension().createContext("warningIcon");
        context.setActivity(this);
        functions = context.getFunctions();

        setTextViewText(AppStatus.getInstance().consoleText);

        if (!AppStatus.getInstance().started) {
            callFunction("registerSettings", createSettings());
            callFunction("checkForNotificationAction");
            AppStatus.getInstance().started = true;
        }
    }

    private FREObject callFunction(String name, FREObject... params) {
        return functions.get(name).call(context, params);
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

    private FREByteArray getFREByteArray(byte[] value) {
        return FREByteArray.newByteArray(value);
    }

    private FREObject createNotification() {
        try {
            Map<String, FREObject> notification = new HashMap<>();
            notification.put("fireDate", createDate());
            notification.put("playSound", getFREObject(true));
            notification.put("soundName", getFREObject("fx05.wav"));
            notification.put("title", getFREObject("Title"));
            notification.put("body", getFREObject("Hello"));
            notification.put("iconType", getFREObject("icon"));
            notification.put("numberAnnotation", getFREObject(2));
            notification.put("cancelOnSelect", getFREObject(true));
            notification.put("isExact", getFREObject(true));
            //notification.put("repeatInterval", getFREObject(LocalNotificationTimeInterval.MINUTE_CALENDAR_UNIT));
            notification.put("showInForeground", getFREObject(true));
            notification.put("actionData", getFREByteArray("Hello World!".getBytes()));
            notification.put("category", getFREObject(cat));
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
            Map<String, FREObject> category1 = new HashMap<>();
            category1.put("identifier", getFREObject("CategoryX"));
            category1.put("name", getFREObject("Test1"));
            category1.put("useCustomDismissAction", getFREObject(true));
            category1.put("actions", createActions());

            return getFREArray(FREObject.newObject(category1));
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
        setTextViewText("");
    }

    public void onPost(View view) {
        FREObject notification = createNotification();
        printNotifyUser(notification);
        callFunction("notify", getFREObject("JKCode"), notification);
    }

    private void printNotifyUser(FREObject notification) {
        String message = String.format(
                "fireDate: %d\n" +
                "playSound: %s\n" +
                "soundName: %s\n" +
                "title: %s\n" +
                "body: %s\n" +
                "iconType: %s\n" +
                "numberAnnotation: %d\n" +
                "cancelOnSelect: %s\n" +
                "showInForeground: %s\n" +
                "actionData: %s\n" +
                "category: %s",
                (long)notification.getProperty("fireDate").getProperty("time").getAsDouble(),
                notification.getProperty("playSound").getAsBool(),
                notification.getProperty("soundName").getAsString(),
                notification.getProperty("title").getAsString(),
                notification.getProperty("body").getAsString(),
                notification.getProperty("iconType").getAsString(),
                notification.getProperty("numberAnnotation").getAsInt(),
                notification.getProperty("cancelOnSelect").getAsBool(),
                notification.getProperty("showInForeground").getAsBool(),
                byteArrayToString(notification.getProperty("actionData")),
                notification.getProperty("category").getAsString()
        );
        printMessage(message, "Post Notification");
    }

    private String byteArrayToString(FREObject value) {
        return new String(((FREByteArray)value).getBytes().array(), Charset.forName("UTF-8"));
    }

    public void onCancel(View view) {
        callFunction("cancel", getFREObject("JKCode"));
    }

    public void onCancelAll(View view) {
        callFunction("cancelAll");
    }

    private void printMessage(String message, String title) {
        String formattedMessage = getMessage(message, title);

        AppStatus.getInstance().consoleText = formattedMessage;
        setTextViewText(formattedMessage);
    }

    private void setTextViewText(String text) {
        textView.setText(text);
    }

    private String getMessage(String message, String title) {
        String newTitle = title.length() != 0? title + "\n" : title;
        return String.format("%s-----\n%s%s\n", textView.getText(), newTitle, message);
    }

    public void dispatchStatusEvent(String code, String level) {
        if (code.equals("notificationSelected")) {
            didReceiveNotification();
        }
        else if (code.equals("settingsSubscribed")) {
            didSubscribedSettings();
        }
    }

    private void didSubscribedSettings() {
        String string = String.format("%d",
                callFunction("getSelectedSettings").getAsInt());
        printMessage(string, "Registered Notification");
    }

    private void didReceiveNotification() {
        String message = String.format("%s\n%s\n%s\n%s",
                callFunction("getSelectedNotificationCode").getAsString(),
                byteArrayToString(callFunction("getSelectedNotificationData")),
                callFunction("getSelectedNotificationAction").getAsString(),
                callFunction("getSelectedNotificationUserResponse").getAsString());
        printMessage(message, "Received Notification");
    }
}
