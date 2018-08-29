package com.juankpro.ane.localnotif;

import android.content.Context;
import android.os.Build;

import com.juankpro.ane.localnotif.factory.NotificationStrategyFactory;
import com.juankpro.ane.localnotif.notifier.KitKatNotifier;
import com.juankpro.ane.localnotif.notifier.LegacyNotifier;
import com.juankpro.ane.localnotif.notifier.MarshmallowNotifier;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.powermock.reflect.Whitebox;

import static org.junit.Assert.assertTrue;

@RunWith(PowerMockRunner.class)
@PrepareForTest({Build.VERSION.class})
public class NotificationStrategyFactoryTest {
    @Mock
    private Context context;

    private NotificationStrategyFactory subject;
    private NotificationStrategyFactory getSubject() {
        if (subject == null) { subject = new NotificationStrategyFactory(context); }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    public void factory_create_createsALegacyNotifier_beforeKitKat() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.KITKAT - 1);
        assertTrue(getSubject().create() instanceof LegacyNotifier);
    }

    @Test
    public void factory_create_createsALegacyNotifier_beforeMarshmallow() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.M - 1);
        assertTrue(getSubject().create() instanceof KitKatNotifier);

        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.KITKAT);
        assertTrue(getSubject().create() instanceof KitKatNotifier);
    }

    @Test
    public void factory_create_createsALegacyNotifier_onMarshmallowAndHigher() {
        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.M);
        assertTrue(getSubject().create() instanceof KitKatNotifier);

        Whitebox.setInternalState(Build.VERSION.class, "SDK_INT", Build.VERSION_CODES.N);
        assertTrue(getSubject().create() instanceof MarshmallowNotifier);
    }
}
