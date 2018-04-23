package com.juankpro.ane.testapplication;

public class AppStatus {
    private static AppStatus _instance = new AppStatus();

    public static AppStatus getInstance() {
        return _instance;
    }

    public String consoleText;
    public boolean started;
}
