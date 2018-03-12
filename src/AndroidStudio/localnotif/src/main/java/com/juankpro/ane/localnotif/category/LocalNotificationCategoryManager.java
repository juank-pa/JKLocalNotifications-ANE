package com.juankpro.ane.localnotif.category;

import android.content.Context;

import com.juankpro.ane.localnotif.util.PersistenceManager;

import java.util.Hashtable;

/**
 * Created by jpazmino on 11/22/17.
 */

public class LocalNotificationCategoryManager {
    private Hashtable<String, LocalNotificationCategory> categories;
    private PersistenceManager persistenceManager;

    public LocalNotificationCategoryManager(Context context) {
        persistenceManager = new PersistenceManager(context);
    }

    public void registerCategories(LocalNotificationCategory[] categories) {
        this.categories = new Hashtable<>();
        for(LocalNotificationCategory category:categories) {
            this.categories.put(category.identifier, category);
        }
        persistenceManager.writeCategories(categories);
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
