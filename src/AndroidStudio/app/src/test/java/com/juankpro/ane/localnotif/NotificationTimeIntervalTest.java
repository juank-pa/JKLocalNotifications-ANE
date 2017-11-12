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
        assertEquals(
                (long)1000 * 60 * 60 * 24 * 365,
                getSubject(NotificationTimeInterval.YEAR_CALENDAR_UNIT).toMilliseconds()
        );
    }

    @Test
    public void notificationTimeInterval_monthInterval_toMilliseconds() {
        assertEquals(
                (long)1000 * 60 * 60 * 24 * 30,
                getSubject(NotificationTimeInterval.MONTH_CALENDAR_UNIT).toMilliseconds()
        );
    }

    @Test
    public void notificationTimeInterval_dayInterval_toMilliseconds() {
        assertEquals(
                1000 * 60 * 60 * 24,
                getSubject(NotificationTimeInterval.DAY_CALENDAR_UNIT).toMilliseconds()
        );
    }

    @Test
    public void notificationTimeInterval_hourInterval_toMilliseconds() {
        assertEquals(
                1000 * 60 * 60,
                getSubject(NotificationTimeInterval.HOUR_CALENDAR_UNIT).toMilliseconds()
        );
    }

    @Test
    public void notificationTimeInterval_minuteInterval_toMilliseconds() {
        assertEquals(
                1000 * 60,
                getSubject(NotificationTimeInterval.MINUTE_CALENDAR_UNIT).toMilliseconds()
        );
    }

    @Test
    public void notificationTimeInterval_secondInterval_toMilliseconds() {
        assertEquals(
                1000,
                getSubject(NotificationTimeInterval.SECOND_CALENDAR_UNIT).toMilliseconds()
        );
    }

    @Test
    public void notificationTimeInterval_weekInterval_toMilliseconds() {
        assertEquals(
                1000 * 60 * 60 * 24 * 7,
                getSubject(NotificationTimeInterval.WEEK_CALENDAR_UNIT).toMilliseconds()
        );
    }

    @Test
    public void notificationTimeInterval_quarterInterval_toMilliseconds() {
        assertEquals(
                ((long)1000 * 60 * 60 * 24 * 365) / 4,
                getSubject(NotificationTimeInterval.QUARTER_CALENDAR_UNIT).toMilliseconds()
        );
    }

    @Test
    public void notificationTimeInterval_unkownIntervalInterval_returnsZeroMilliseconds() {
        assertEquals(0, getSubject(1 << 20).toMilliseconds());
    }
}
