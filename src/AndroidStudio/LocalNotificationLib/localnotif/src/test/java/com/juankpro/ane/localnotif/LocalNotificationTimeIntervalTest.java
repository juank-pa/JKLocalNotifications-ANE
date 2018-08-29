package com.juankpro.ane.localnotif;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

/**
 * Created by Juank on 10/23/17.
 */

public class LocalNotificationTimeIntervalTest {
    private LocalNotificationTimeInterval getSubject(int interval) {
        return new LocalNotificationTimeInterval(interval);
    }

    @Test
    public void notificationTimeInterval_yearInterval_toMilliseconds() {
        assertEquals(
                (long)1000 * 60 * 60 * 24 * 365,
                getSubject(LocalNotificationTimeInterval.YEAR_CALENDAR_UNIT).toMilliseconds()
        );
    }

    @Test
    public void notificationTimeInterval_monthInterval_toMilliseconds() {
        assertEquals(
                (long)1000 * 60 * 60 * 24 * 30,
                getSubject(LocalNotificationTimeInterval.MONTH_CALENDAR_UNIT).toMilliseconds()
        );
    }

    @Test
    public void notificationTimeInterval_dayInterval_toMilliseconds() {
        assertEquals(
                1000 * 60 * 60 * 24,
                getSubject(LocalNotificationTimeInterval.DAY_CALENDAR_UNIT).toMilliseconds()
        );
    }

    @Test
    public void notificationTimeInterval_hourInterval_toMilliseconds() {
        assertEquals(
                1000 * 60 * 60,
                getSubject(LocalNotificationTimeInterval.HOUR_CALENDAR_UNIT).toMilliseconds()
        );
    }

    @Test
    public void notificationTimeInterval_minuteInterval_toMilliseconds() {
        assertEquals(
                1000 * 60,
                getSubject(LocalNotificationTimeInterval.MINUTE_CALENDAR_UNIT).toMilliseconds()
        );
    }

    @Test
    public void notificationTimeInterval_secondInterval_toMilliseconds() {
        assertEquals(
                1000,
                getSubject(LocalNotificationTimeInterval.SECOND_CALENDAR_UNIT).toMilliseconds()
        );
    }

    @Test
    public void notificationTimeInterval_weekInterval_toMilliseconds() {
        assertEquals(
                1000 * 60 * 60 * 24 * 7,
                getSubject(LocalNotificationTimeInterval.WEEK_CALENDAR_UNIT).toMilliseconds()
        );
    }

    @Test
    public void notificationTimeInterval_quarterInterval_toMilliseconds() {
        assertEquals(
                (long)1000 * 60 * 60 * 24 * 91,
                getSubject(LocalNotificationTimeInterval.QUARTER_CALENDAR_UNIT).toMilliseconds()
        );
    }

    @Test
    public void notificationTimeInterval_unkownIntervalInterval_returnsZeroMilliseconds() {
        assertEquals(0, getSubject(1 << 20).toMilliseconds());
    }

    @Test
    public void notificationTimeInterval_toMillisecondsWithParameter_multipliesIntervalByParameter() {
        assertEquals(
                4000,
                getSubject(LocalNotificationTimeInterval.SECOND_CALENDAR_UNIT).toMilliseconds(4)
        );
    }


}
