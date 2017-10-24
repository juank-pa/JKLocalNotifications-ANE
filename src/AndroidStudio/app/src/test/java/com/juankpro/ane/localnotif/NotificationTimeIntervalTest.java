package com.juankpro.ane.localnotif;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

/**
 * Created by Juank on 10/23/17.
 */

public class NotificationTimeIntervalTest {
    private NotificationTimeInterval getSubject(int interval) {
        return new NotificationTimeInterval(interval);
    }

    @Test
    public void notificationTimeInterval_yearInterval_toMilliseconds() {
        assertEquals(getSubject(
                NotificationTimeInterval.YEAR_CALENDAR_UNIT).toMilliseconds(),
                (long)1000 * 60 * 60 * 24 * 365
        );
    }

    @Test
    public void notificationTimeInterval_monthInterval_toMilliseconds() {
        assertEquals(getSubject(
                NotificationTimeInterval.MONTH_CALENDAR_UNIT).toMilliseconds(),
                (long)1000 * 60 * 60 * 24 * 30
        );
    }

    @Test
    public void notificationTimeInterval_dayInterval_toMilliseconds() {
        assertEquals(
                getSubject(NotificationTimeInterval.DAY_CALENDAR_UNIT).toMilliseconds(),
                1000 * 60 * 60 * 24
        );
    }

    @Test
    public void notificationTimeInterval_hourInterval_toMilliseconds() {
        assertEquals(
                getSubject(NotificationTimeInterval.HOUR_CALENDAR_UNIT).toMilliseconds(),
                1000 * 60 * 60
        );
    }

    @Test
    public void notificationTimeInterval_minuteInterval_toMilliseconds() {
        assertEquals(
                getSubject(NotificationTimeInterval.MINUTE_CALENDAR_UNIT).toMilliseconds(),
                1000 * 60);
    }

    @Test
    public void notificationTimeInterval_secondInterval_toMilliseconds() {
        assertEquals(
                getSubject(NotificationTimeInterval.SECOND_CALENDAR_UNIT).toMilliseconds(),
                1000
        );
    }

    @Test
    public void notificationTimeInterval_weekInterval_toMilliseconds() {
        assertEquals(
                getSubject(NotificationTimeInterval.WEEK_CALENDAR_UNIT).toMilliseconds(),
                1000 * 60 * 60 * 24 * 7);
    }

    @Test
    public void notificationTimeInterval_quarterInterval_toMilliseconds() {
        assertEquals(
                getSubject(NotificationTimeInterval.QUARTER_CALENDAR_UNIT).toMilliseconds(),
                ((long)1000 * 60 * 60 * 24 * 365) / 4);
    }

    @Test
    public void notificationTimeInterval_unkownIntervalInterval_returnsZeroMilliseconds() {
        assertEquals(getSubject(1 << 20).toMilliseconds(), 0);
    }
}
