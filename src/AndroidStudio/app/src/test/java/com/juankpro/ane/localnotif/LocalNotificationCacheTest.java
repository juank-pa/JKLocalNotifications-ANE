package com.juankpro.ane.localnotif;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Created by Juank on 10/23/17.
 */

public class LocalNotificationCacheTest {
    private LocalNotificationCache subject;
    private LocalNotificationCache getSubject() {
        if (subject == null) {
            LocalNotificationCache.clear();
            subject = LocalNotificationCache.getInstance();
        }
        return subject;
    }

    @Test
    public void notificationCache_setDataForSelectedNotification() {
        byte[] data = {0};
        getSubject().setData("My Code", data);
        assertEquals(getSubject().getNotificationCode(), "My Code");
        assertEquals(getSubject().getNotificationData(), data);
    }

    @Test
    public void notificationCache_settingData_marksCacheAsUpdated() {
        assertFalse(getSubject().wasUpdated());
        getSubject().setData("My Code", new byte[]{0});
        assertTrue(getSubject().wasUpdated());
    }

    @Test
    public void notificationCache_reset_marksCacheAsNotUpdated() {
        getSubject().setData("My Code", new byte[]{0});
        assertTrue(getSubject().wasUpdated());

        getSubject().reset();

        assertFalse(getSubject().wasUpdated());
    }

    @Test
    public void notificationCache_reset_leavesDataUntouched() {
        byte[] data = {0};
        getSubject().setData("My Code", data);
        assertTrue(getSubject().wasUpdated());

        getSubject().reset();

        assertEquals(getSubject().getNotificationCode(), "My Code");
        assertEquals(getSubject().getNotificationData(), data);
    }

    @Test
    public void notificationCache_clear_createsANewInstance() {
        LocalNotificationCache previousCache = LocalNotificationCache.getInstance();
        previousCache.setData("My Code", new byte[]{0});

        assertSame(previousCache, LocalNotificationCache.getInstance());
        assertTrue(previousCache.wasUpdated());

        LocalNotificationCache.clear();

        LocalNotificationCache newCache = LocalNotificationCache.getInstance();
        assertNotSame(previousCache, newCache);
        assertNull(newCache.getNotificationCode());
        assertNull(newCache.getNotificationData());
        assertFalse(newCache.wasUpdated());
    }
}
