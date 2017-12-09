package com.juankpro.ane.localnotif;

import com.juankpro.ane.localnotif.util.ApplicationStatus;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

/**
 * Created by Juank on 10/23/17.
 */

public class ApplicationStatusTest {
    @Before
    public void setup() {
        ApplicationStatus.reset();
    }

    @Test
    public void applicationStatus_initializedAsActive() {
        assertFalse(ApplicationStatus.getActive());
    }

    @Test
    public void applicationStatus_initializedAsInBackground() {
        assertFalse(ApplicationStatus.getInForeground());
    }

    @Test
    public void applicationStatus_settingInForeground_activatesAlso() {
        ApplicationStatus.setInForeground(true);
        assertTrue(ApplicationStatus.getInForeground());
        assertTrue(ApplicationStatus.getActive());
    }

    @Test
    public void applicationStatus_settingInBackgroundFirstTime_doesNothing() {
        ApplicationStatus.setInForeground(false);
        assertFalse(ApplicationStatus.getActive());
        assertFalse(ApplicationStatus.getInForeground());
    }

    @Test
    public void applicationStatus_settingInBackground_whenInForeground_doesNotAffectActive() {
        ApplicationStatus.setInForeground(true);
        ApplicationStatus.setInForeground(false);
        assertTrue(ApplicationStatus.getActive());
        assertFalse(ApplicationStatus.getInForeground());
    }

    @Test
    public void applicationStatus_reset_resetsToFalse() {
        ApplicationStatus.setInForeground(true);
        assertTrue(ApplicationStatus.getActive());
        assertTrue(ApplicationStatus.getInForeground());

        ApplicationStatus.reset();
        assertFalse(ApplicationStatus.getActive());
        assertFalse(ApplicationStatus.getInForeground());
    }
}
