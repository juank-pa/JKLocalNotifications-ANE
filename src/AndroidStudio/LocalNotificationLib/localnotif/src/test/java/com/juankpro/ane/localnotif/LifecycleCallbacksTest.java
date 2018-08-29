package com.juankpro.ane.localnotif;

import android.app.Activity;
import android.content.Intent;

import com.juankpro.ane.localnotif.util.ApplicationStatus;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.modules.junit4.PowerMockRunner;

import static junit.framework.Assert.assertFalse;
import static junit.framework.Assert.assertTrue;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Created by juancarlospazmino on 3/12/18.
 */

@RunWith(PowerMockRunner.class)
public class LifecycleCallbacksTest {
    @Mock
    private Activity activity;
    @Mock
    private Intent intent;
    private LifecycleCallbacks subject;

    private LifecycleCallbacks getSubject() {
        if (subject == null) {
            subject = new LifecycleCallbacks();
        }
        return subject;
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    public void callbacks_setAppInForeground_whenActivityStarted() {
        ApplicationStatus.setInForeground(false);
        getSubject().onActivityStarted(null);
        assertTrue(ApplicationStatus.getInForeground());
    }

    @Test
    public void callbacks_setAppInForeground_whenActivityStopped() {
        ApplicationStatus.setInForeground(true);
        getSubject().onActivityStopped(null);
        assertFalse(ApplicationStatus.getInForeground());
    }

    @Test
    public void callbacks_doesNothing_whenNullIntent() {
        when(activity.getIntent()).thenReturn(null);
        getSubject().onActivityCreated(activity, null);
        verify(activity, never()).moveTaskToBack(true);
    }

    @Test
    public void callbacks_doesNothing_whenNotInBackgroundMode() {
        when(activity.getIntent()).thenReturn(intent);
        when(intent.getBooleanExtra(Constants.BACKGROUND_MODE_KEY, false)).thenReturn(false);

        getSubject().onActivityCreated(activity, null);
        verify(activity, never()).moveTaskToBack(true);
    }

    @Test
    public void callbacks_hideActivity_whenInBackgroundMode() {
        when(activity.getIntent()).thenReturn(intent);
        when(intent.getBooleanExtra(Constants.BACKGROUND_MODE_KEY, false)).thenReturn(true);

        getSubject().onActivityCreated(activity, null);
        verify(activity).moveTaskToBack(true);
    }
}
