package com.juankpro.ane.localnotif;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static junit.framework.Assert.assertSame;
import static org.mockito.Mockito.when;

/**
 * Created by juank on 11/26/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest(LocalNotificationsContext.class)
public class ExtensionTest {
    @Mock
    private LocalNotificationsContext context;
    private Extension subject;

    public Extension getSubject() {
        if (subject == null) {
            subject = new Extension();
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    public void extension_createContext_returnsContext() {
        PowerMockito.mockStatic(LocalNotificationsContext.class);
        when(LocalNotificationsContext.getInstance()).thenReturn(context);
        assertSame(context, getSubject().createContext("anyId"));
    }
}
