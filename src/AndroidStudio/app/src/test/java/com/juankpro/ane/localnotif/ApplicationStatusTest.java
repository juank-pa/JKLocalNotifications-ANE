package com.juankpro.ane.localnotif;

import org.junit.Test;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

/**
 * Created by Juank on 10/23/17.
 */

public class ApplicationStatusTest {
    private void setup() {
        ApplicationStatus.reset();
    }

    @Test
    public void applicationStatus_initializedAsActive() {
        setup();
        assertFalse(ApplicationStatus.getActive());
    }

    @Test
    public void applicationStatus_initializedAsInBackground() {
        setup();
        assertFalse(ApplicationStatus.getInForeground());
    }

    @Test
    public void applicationStatus_settingInForeground_activatesAlso() {
        setup();
        ApplicationStatus.setInForeground(true);
        assertTrue(ApplicationStatus.getInForeground());
        assertTrue(ApplicationStatus.getActive());
    }

    @Test
    public void applicationStatus_settingInBackgroundFirstTime_doesNothing() {
        setup();
        ApplicationStatus.setInForeground(false);
        assertFalse(ApplicationStatus.getActive());
        assertFalse(ApplicationStatus.getInForeground());
    }

    @Test
    public void applicationStatus_settingInBackground_whenInForeground_doesNotAffectActive() {
        setup();
        ApplicationStatus.setInForeground(true);
        ApplicationStatus.setInForeground(false);
        assertTrue(ApplicationStatus.getActive());
        assertFalse(ApplicationStatus.getInForeground());
    }

    @Test
    public void applicationStatus_reset_resetsToFalse() {
        setup();
        ApplicationStatus.setInForeground(true);
        assertTrue(ApplicationStatus.getActive());
        assertTrue(ApplicationStatus.getInForeground());

        ApplicationStatus.reset();
        assertFalse(ApplicationStatus.getActive());
        assertFalse(ApplicationStatus.getInForeground());
    }
}
