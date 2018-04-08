package com.juankpro.ane.localnotif;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.media.AudioAttributes;
import android.net.Uri;
import android.os.Build;

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
import org.powermock.reflect.Whitebox;

import java.util.Hashtable;

import static junit.framework.Assert.assertNull;
import static junit.framework.Assert.assertSame;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.powermock.api.mockito.PowerMockito.doNothing;
import static org.powermock.api.mockito.PowerMockito.mockStatic;
import static org.powermock.api.mockito.PowerMockito.spy;
import static org.powermock.api.mockito.PowerMockito.verifyStatic;

/**
 * Created by juank on 11/25/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({LocalNotificationCategoryManager.class, Build.class, NotificationSoundProvider.class})
public class LocalNotificationCategoryManagerTest {
    @Mock
    private Context context;
    @Mock
    private PersistenceManager persistenceManager;
    @Mock
    private NotificationChannel channel;
    @Mock
    private NotificationManager notificationManager;
    @Mock
    private Uri uri;
    private ApplicationInfo appInfo;
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
        category1.soundName = "sound.mp3";
        category1.name = "CategoryX";
        category1.description = "Category Description";
        category1.importance = NotificationManager.IMPORTANCE_HIGH;
        category1.shouldVibrate = true;
        LocalNotificationCategory category2 = new LocalNotificationCategory();
        category2.identifier = "cat2";
        return new LocalNotificationCategory[]{category1, category2};
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.O - 1);

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

    private void setupOreo() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.O);
        setupChannels();
    }

    private void setupChannels() {
        try {
            PowerMockito.whenNew(NotificationChannel.class)
                    .withArguments(anyString(), anyString(), anyInt())
                    .thenReturn(channel);
        } catch (Throwable e) { e.printStackTrace(); }
        when(context.getSystemService(Context.NOTIFICATION_SERVICE)).thenReturn(notificationManager);
        doNothing().when(notificationManager).createNotificationChannel(channel);

        appInfo = new ApplicationInfo();
        appInfo.targetSdkVersion = Build.VERSION_CODES.O;
        when(context.getApplicationInfo()).thenReturn(appInfo);

        mockStatic(NotificationSoundProvider.class);
        when(NotificationSoundProvider.getSoundUri(anyString())).thenReturn(uri);
        doNothing().when(channel).setSound(any(Uri.class), any(AudioAttributes.class));
    }

    @Test
    public void manager_registerCategories_inOreoAndHigher_createsAndRegistersChannel() throws Exception {
        setupOreo();

        LocalNotificationCategory category = getCategories()[0];
        getSubject().registerCategories(new LocalNotificationCategory[]{category});

        PowerMockito.verifyNew(NotificationChannel.class).withArguments(category.identifier, category.name, category.importance);

        verify(channel).setDescription(category.description);
        verify(channel).enableVibration(true);
        verify(channel).setSound(uri, Notification.AUDIO_ATTRIBUTES_DEFAULT);
        verify(notificationManager).createNotificationChannel(channel);

        verifyStatic(NotificationSoundProvider.class);
        NotificationSoundProvider.getSoundUri("sound.mp3");
    }

    @Test
    public void manager_registerCategories_inOreoAndHigher_targetingLowerThanOreo_doesNotCreateNorRegisterChannel() throws Exception {
        setupOreo();
        appInfo.targetSdkVersion = Build.VERSION_CODES.O - 1;

        LocalNotificationCategory category = getCategories()[0];
        getSubject().registerCategories(new LocalNotificationCategory[]{category});

        PowerMockito.verifyNew(NotificationChannel.class, never()).withArguments(anyString(), anyString(), anyInt());
        verify(notificationManager, never()).createNotificationChannel(channel);
    }

    @Test
    public void manager_registerCategories_inOreoAndHigher_ifNameIsNull_doesNotCreatesNorRegisterChannel() throws Exception {
        setupOreo();

        LocalNotificationCategory category = getCategories()[0];
        category.name = null;
        getSubject().registerCategories(new LocalNotificationCategory[]{category});

        PowerMockito.verifyNew(NotificationChannel.class, never()).withArguments(anyString(), anyString(), anyInt());
        verify(notificationManager, never()).createNotificationChannel(channel);
    }

    @Test
    public void manager_registerCategories_inOreoAndHigher_ifSoundNameIsNull_doesNotAddSoundToTheChannel() {
        setupOreo();

        LocalNotificationCategory category = getCategories()[0];
        category.soundName = null;
        getSubject().registerCategories(new LocalNotificationCategory[]{category});

        verify(channel, never()).setSound(any(Uri.class), any(AudioAttributes.class));
    }

    @Test
    public void manager_registerCategories_inOreoAndHigher_ifDescriptionIsNull_doesNotSetDescription() {
        setupOreo();

        LocalNotificationCategory category = getCategories()[0];
        category.description = null;
        getSubject().registerCategories(new LocalNotificationCategory[]{category});

        verify(channel, never()).setDescription(anyString());
    }

    @Test
    public void manager_registerCategories_priorToOreo_doesNotCreateNorRegistersAChannel() {
        setupChannels();
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.O - 1);

        LocalNotificationCategory category = getCategories()[0];
        getSubject().registerCategories(new LocalNotificationCategory[]{category});

        verify(notificationManager, never()).createNotificationChannel(channel);
    }

}
