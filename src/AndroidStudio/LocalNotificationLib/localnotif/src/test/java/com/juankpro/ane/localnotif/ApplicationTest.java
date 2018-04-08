package com.juankpro.ane.localnotif;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.mockito.Mockito.verify;
import static org.powermock.api.mockito.PowerMockito.spy;
import static org.powermock.api.mockito.PowerMockito.whenNew;
import static org.powermock.api.support.membermodification.MemberMatcher.methodsDeclaredIn;

/**
 * Created by juancarlospazmino on 3/12/18.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({Application.class})
public class ApplicationTest {
    private Application subject;
    @Mock
    private LifecycleCallbacks callbacks;

    private Application getSubject() {
        if (subject == null) {
            subject = spy(new Application());
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        try {
            whenNew(LifecycleCallbacks.class).withNoArguments().thenReturn(callbacks);
        } catch (Throwable e) { e.printStackTrace(); }
        PowerMockito.suppress(methodsDeclaredIn(android.app.Application.class));
    }

    @Test
    public void application_addsCallbacks_onCreate() {
        getSubject().onCreate();
        verify(getSubject()).registerActivityLifecycleCallbacks(callbacks);
    }
}
