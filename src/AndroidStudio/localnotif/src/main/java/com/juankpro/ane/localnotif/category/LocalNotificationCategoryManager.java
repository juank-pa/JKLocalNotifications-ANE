package com.juankpro.ane.localnotif.category;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Build;

import com.juankpro.ane.localnotif.NotificationSoundProvider;
import com.juankpro.ane.localnotif.util.Logger;
import com.juankpro.ane.localnotif.util.PersistenceManager;

import java.util.Hashtable;

/**
 * Created by jpazmino on 11/22/17.
 */

public class LocalNotificationCategoryManager {
    private Hashtable<String, LocalNotificationCategory> categories;
    private PersistenceManager persistenceManager;
    private Context context;

    public LocalNotificationCategoryManager(Context context) {
        this.context = context;
        persistenceManager = new PersistenceManager(context);
    }

    public void registerCategories(LocalNotificationCategory[] categories) {
        this.categories = new Hashtable<>();
        for(LocalNotificationCategory category:categories) {
            this.categories.put(category.identifier, category);
            createNotificationChannel(category);
        }
        persistenceManager.writeCategories(categories);
    }

    private void createNotificationChannel(LocalNotificationCategory category) {
        if (shouldNotRegister(category)) return;
        registerChannel(buildChannel(category));
    }

    private NotificationChannel buildChannel(LocalNotificationCategory category) {
        if (shouldNotRegister(category)) return null;
        Logger.log("Registering category: " + category.identifier + "," + category.name + "," + String.valueOf(category.importance));
        NotificationChannel channel = new NotificationChannel(
                category.identifier, category.name, category.importance
        );
        if (category.description != null) channel.setDescription(category.description);
        buildChannelSound(channel, category);
        channel.enableVibration(category.shouldVibrate);
        return channel;
    }

    private void buildChannelSound(NotificationChannel channel, LocalNotificationCategory category) {
        if (shouldNotRegister(category) || category.soundName == null) return;
        channel.setSound(
                NotificationSoundProvider.getSoundUri(category.soundName),
                Notification.AUDIO_ATTRIBUTES_DEFAULT
        );
    }

    private boolean shouldNotRegister(LocalNotificationCategory category) {
        return category.name == null ||
                Build.VERSION.SDK_INT < Build.VERSION_CODES.O ||
                context.getApplicationInfo().targetSdkVersion < Build.VERSION_CODES.O;
    }

    private void registerChannel(NotificationChannel channel) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return;
        NotificationManager notificationManager =
                (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.createNotificationChannel(channel);
    }

    public LocalNotificationCategory readCategory(String identifier) {
        if (identifier == null) return null;
        if (!getCategories().containsKey(identifier)) {
            LocalNotificationCategory category = persistenceManager.readCategory(identifier);
            if(category == null) return null;
            getCategories().put(identifier, category);
        }
        return getCategories().get(identifier);
    }

    private Hashtable<String, LocalNotificationCategory>getCategories() {
        if (categories == null) categories = new Hashtable<>();
        return categories;
    }
}
