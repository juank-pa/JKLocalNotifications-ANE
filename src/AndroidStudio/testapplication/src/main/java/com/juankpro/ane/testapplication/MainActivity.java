package com.juankpro.ane.testapplication;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.juankpro.ane.localnotif.Extension;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class MainActivity extends Activity {
    private FREContext context;
    private Map<String, FREFunction> functions;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        context = new Extension().createContext("anyId");
        context.setActivity(this);
        functions = context.getFunctions();

        functions.get("checkForNotificationAction").call(null, new FREObject[] {});
        functions.get("registerSettings").call(context, new FREObject[] { createSettings() });
    }

    public void onPost(View view) {
        functions.get("notify").call(context, new FREObject[] {FREObject.newObject("JKCode"), createNotification()});
    }

    private FREObject createNotification() {
        try {
            Map<String, FREObject> notification = new HashMap<>();
            notification.put("fireDate", createDate());
            notification.put("title", FREObject.newObject("Title"));
            notification.put("body", FREObject.newObject("Body"));
            notification.put("iconType", FREObject.newObject("icon"));
            notification.put("cancelOnSelect", FREObject.newObject(true));
            notification.put("showInForeground", FREObject.newObject(false));
            notification.put("category", FREObject.newObject("Category"));

            return FREObject.newObject(notification);
        }
        catch(Throwable e) {

        }
        return null;
    }

    private FREObject createSettings() {
        try {
            Map<String, FREObject> notification = new HashMap<>();
            notification.put("categories", createCategories());

            return FREObject.newObject(notification);
        }
        catch(Throwable e) {

        }
        return null;
    }

    private FREArray createCategories() {
        try {
            Map<String, FREObject> notification = new HashMap<>();
            notification.put("identifier", FREObject.newObject("Category"));
            notification.put("actions", createActions());

            return FREArray.newArray(new FREObject[] { FREObject.newObject(notification) });
        }
        catch(Throwable e) {

        }
        return null;
    }

    private FREArray createActions() {
        try {
            Map<String, FREObject> action1 = new HashMap<>();
            action1.put("identifier", FREObject.newObject("OKButton"));
            action1.put("title", FREObject.newObject("OK"));
            action1.put("icon", FREObject.newObject("any"));
            action1.put("isBackground", FREObject.newObject(true));

            Map<String, FREObject> action2 = new HashMap<>();
            action2.put("identifier", FREObject.newObject("CancelButton"));
            action2.put("title", FREObject.newObject("Cancel"));
            action2.put("icon", FREObject.newObject("any"));
            action2.put("isBackground", FREObject.newObject(false));

            return FREArray.newArray(new FREObject[] { FREObject.newObject(action1), FREObject.newObject(action2) } );
        }
        catch(Throwable e) {

        }
        return null;
    }

    private FREObject createDate() {
        try {
            Map<String, FREObject> date = new HashMap<>();
            date.put("time", FREObject.newObject((double)new Date().getTime() + 5000));
            return FREObject.newObject(date);
        }
        catch(Throwable e) {

        }
        return null;
    }
}
