package com.juankpro.ane.localnotif;

import android.content.Context;

import com.juankpro.ane.localnotif.category.LocalNotificationCategory;
import com.juankpro.ane.localnotif.category.LocalNotificationCategoryManager;
import com.juankpro.ane.localnotif.util.PersistenceManager;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import java.util.Hashtable;

import static junit.framework.Assert.assertNull;
import static junit.framework.Assert.assertSame;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.powermock.api.mockito.PowerMockito.spy;

/**
 * Created by juank on 11/25/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({LocalNotificationCategoryManager.class})
public class LocalNotificationCategoryManagerTest {
    @Mock
    private Context context;
    @Mock
    private PersistenceManager persistenceManager;
    private LocalNotificationCategoryManager subject;

    private LocalNotificationCategoryManager getSubject() {
        if (subject == null) {
            subject = new LocalNotificationCategoryManager(context);
        }
        return subject;
    }

    private LocalNotificationCategory[] getCategories() {
        LocalNotificationCategory category1 = new LocalNotificationCategory();
        category1.identifier = "cat1";
        LocalNotificationCategory category2 = new LocalNotificationCategory();
        category2.identifier = "cat2";
        return new LocalNotificationCategory[]{category1, category2};
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);

        try {
            PowerMockito.whenNew(PersistenceManager.class)
                    .withArguments(context)
                    .thenReturn(persistenceManager);
        } catch (Throwable e) { e.printStackTrace(); }
    }

    @Test
    public void manager_registerCategories_cachesCategoriesInAHash() {
        Hashtable<String, LocalNotificationCategory> categoryHash =
                spy(new Hashtable<String, LocalNotificationCategory>());

        try {
            PowerMockito.whenNew(Hashtable.class).withNoArguments().thenReturn(categoryHash);
        } catch (Throwable e) { e.printStackTrace(); }

        LocalNotificationCategory[] categories = getCategories();

        getSubject().registerCategories(categories);
        verify(categoryHash).put("cat1", categories[0]);
        verify(categoryHash).put("cat2", categories[1]);
    }

    @Test
    public void manager_registerCategories_persistCategories() {
        LocalNotificationCategory[] categories = getCategories();
        getSubject().registerCategories(categories);
        verify(persistenceManager).writeCategories(categories);
    }

    @Test
    public void manager_readCategory_readsFromCacheIfAlreadyAvailable() {
        LocalNotificationCategory[] categories = getCategories();
        getSubject().registerCategories(categories);

        assertSame(categories[0], getSubject().readCategory("cat1"));
        verify(persistenceManager, never()).readCategory("cat1");
    }

    @Test
    public void manager_readCategory_readsFromDiskIfNotInCache() {
        LocalNotificationCategory[] categories = getCategories();

        when(persistenceManager.readCategory("cat1")).thenReturn(categories[0]);

        assertSame(categories[0], getSubject().readCategory("cat1"));
        verify(persistenceManager).readCategory("cat1");
    }

    @Test
    public void manager_readCategory_returnsNullIfNotInCacheNorInDisk() {
        when(persistenceManager.readCategory("cat1")).thenReturn(null);
        assertNull(getSubject().readCategory("cat1"));
        verify(persistenceManager).readCategory("cat1");
    }
}
