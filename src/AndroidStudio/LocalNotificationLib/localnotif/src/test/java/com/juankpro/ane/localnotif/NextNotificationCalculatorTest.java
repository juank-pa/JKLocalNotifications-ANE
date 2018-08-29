package com.juankpro.ane.localnotif;

import com.juankpro.ane.localnotif.util.NextNotificationCalculator;

import org.junit.Test;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import static com.juankpro.ane.localnotif.LocalNotificationTimeInterval.YEAR_CALENDAR_UNIT;
import static com.juankpro.ane.localnotif.LocalNotificationTimeInterval.MONTH_CALENDAR_UNIT;
import static com.juankpro.ane.localnotif.LocalNotificationTimeInterval.DAY_CALENDAR_UNIT;
import static com.juankpro.ane.localnotif.LocalNotificationTimeInterval.HOUR_CALENDAR_UNIT;
import static com.juankpro.ane.localnotif.LocalNotificationTimeInterval.MINUTE_CALENDAR_UNIT;
import static com.juankpro.ane.localnotif.LocalNotificationTimeInterval.SECOND_CALENDAR_UNIT;
import static com.juankpro.ane.localnotif.LocalNotificationTimeInterval.WEEK_CALENDAR_UNIT;
import static com.juankpro.ane.localnotif.LocalNotificationTimeInterval.QUARTER_CALENDAR_UNIT;


        import static org.junit.Assert.assertEquals;

public class NextNotificationCalculatorTest {
    private NextNotificationCalculator getSubject(LocalNotification notification) {
        return new NextNotificationCalculator(notification);
    }

    private LocalNotification notificationAfter(Date now, long ms) {
        return notificationAfter(now, ms, 0);
    }

    private LocalNotification notificationAfter(Date now, long ms, int repeatInterval) {
        LocalNotification notification = new LocalNotification();
        notification.fireDate = dateAfter(now, ms);
        notification.repeatInterval = repeatInterval;
        return notification;
    }

    private LocalNotification notificationAt(Date date, int repeatInterval) {
        return notificationAfter(date, 0, repeatInterval);
    }

    private Date dateAfter(Date now, long ms) {
        return new Date(now.getTime() + ms);
    }

    private Date dateAt(int year, int month, int date, int hour, int minute, int second) {
        Calendar c = GregorianCalendar.getInstance();
        c.set(year, month, date, hour, minute, second);
        c.set(Calendar.MILLISECOND, 10);
        return c.getTime();
    }

    private Date dateAt(int year, int month, int date) {
        return dateAt(year, month, date, 0, 0, 0);
    }

    @Test
    public void calculator_getTime_alwaysReturnsFireTimeForNonRepeatingNotifications() {
        int[] relativeTimes = new int[] {
                100, // Future notification fire date
                -100 // Past notification past date
        };
        Date now = new Date();

        for (int relativeTime : relativeTimes) {
            assertEquals(
                    now.getTime() + relativeTime,
                    getSubject(notificationAfter(now, relativeTime)).getTime(now)
            );
        }
    }

    @Test
    public void calculator_getTime_forRepeatingNotifications_whenFiringRightNowOrInTheFuture_alwaysReturnsFireTime() {
        int[] intervals = new int[] {
                YEAR_CALENDAR_UNIT,
                MONTH_CALENDAR_UNIT,
                DAY_CALENDAR_UNIT,
                HOUR_CALENDAR_UNIT,
                MINUTE_CALENDAR_UNIT,
                SECOND_CALENDAR_UNIT,
                WEEK_CALENDAR_UNIT,
                QUARTER_CALENDAR_UNIT
        };
        Date now = new Date();
        Date futureFireDate = dateAfter(now,5000);

        // Firing right now
        for (int i = 0; i < intervals.length; i++) {
            int interval = intervals[i];
            LocalNotification notification = notificationAt(now, interval);
            assertEquals(
                    now.getTime(),
                    getSubject(notification).getTime(now)
            );
        }

        // Firing in the future
        for (int i = 0; i < intervals.length; i++) {
            int interval = intervals[i];
            LocalNotification notification = notificationAt(futureFireDate, interval);
            assertEquals(
                    futureFireDate.getTime(),
                    getSubject(notification).getTime(now)
            );
        }
    }

    @Test
    public void calculator_getTime_forDailyNotifications_firingInThePast_returnsNextRegularTime() {
        Date fireDate = dateAt(2017, 0, 31, 10, 20, 15);

        Date beforeTime = dateAt(2018, 1, 2, 8, 5, 2);

        assertEquals(
                dateAt(2018, 1, 2, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, DAY_CALENDAR_UNIT)
                ).getTime(beforeTime)
        );

        Date atTime = dateAt(2018, 1, 2, 10, 20, 15);

        assertEquals(
                dateAt(2018, 1, 2, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, DAY_CALENDAR_UNIT)
                ).getTime(atTime)
        );

        Date afterTime = dateAt(2018, 1, 2, 10, 20, 20);

        assertEquals(
                dateAt(2018, 1, 3, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, DAY_CALENDAR_UNIT)
                ).getTime(afterTime)
        );
    }

    @Test
    public void calculator_getTime_forHourlyNotifications_firingInThePast_returnsNextRegularTime() {
        Date fireDate = dateAt(2017, 0, 31, 10, 20, 15);

        Date beforeTime = dateAt(2018, 1, 2, 8, 5, 2);

        assertEquals(
                dateAt(2018, 1, 2, 8, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, HOUR_CALENDAR_UNIT)
                ).getTime(beforeTime)
        );

        Date atTime = dateAt(2018, 1, 2, 8, 20, 15);

        assertEquals(
                dateAt(2018, 1, 2, 8, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, HOUR_CALENDAR_UNIT)
                ).getTime(atTime)
        );

        Date afterTime = dateAt(2018, 1, 2, 8, 20, 20);

        assertEquals(
                dateAt(2018, 1, 2, 9, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, HOUR_CALENDAR_UNIT)
                ).getTime(afterTime)
        );
    }

    @Test
    public void calculator_getTime_forEveryMinuteNotifications_firingInThePast_returnsNextRegularTime() {
        Date fireDate = dateAt(2017, 0, 31, 10, 20, 15);

        Date beforeTime = dateAt(2018, 1, 2, 8, 5, 2);

        assertEquals(
                dateAt(2018, 1, 2, 8, 5, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, MINUTE_CALENDAR_UNIT)
                ).getTime(beforeTime)
        );

        Date atTime = dateAt(2018, 1, 2, 8, 5, 15);

        assertEquals(
                dateAt(2018, 1, 2, 8, 5, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, MINUTE_CALENDAR_UNIT)
                ).getTime(atTime)
        );

        Date afterTime = dateAt(2018, 1, 2, 8, 5, 20);

        assertEquals(
                dateAt(2018, 1, 2, 8, 6, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, MINUTE_CALENDAR_UNIT)
                ).getTime(afterTime)
        );
    }

    @Test
    public void calculator_getTime_forWeeklyNotifications_firingInThePast_returnsNextRegularTime() {
        // Triggers on a Tuesday
        Date fireDate = dateAt(2017, 0, 31, 10, 20, 15);

        Date beforeTime = dateAt(2018, 1, 2, 8, 5, 2);

        assertEquals(
                dateAt(2018, 1, 6, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, WEEK_CALENDAR_UNIT)
                ).getTime(beforeTime)
        );

        Date atTime = dateAt(2018, 1, 6, 10, 20, 15);

        assertEquals(
                dateAt(2018, 1, 6, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, WEEK_CALENDAR_UNIT)
                ).getTime(atTime)
        );

        Date afterTime = dateAt(2018, 1, 6, 10, 20, 20);

        assertEquals(
                dateAt(2018, 1, 13, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, WEEK_CALENDAR_UNIT)
                ).getTime(afterTime)
        );
    }

    @Test
    public void calculator_getTime_forQuarterlyNotifications_firingInThePast_returnsNextRegularTime() {
        // Trigger every 91 days preserving time
        Date fireDate = dateAt(2017, 0, 31, 10, 20, 15);

        Date beforeTime = dateAt(2018, 0, 2, 8, 5, 2);

        assertEquals(
                dateAt(2018, 0, 30, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, QUARTER_CALENDAR_UNIT)
                ).getTime(beforeTime)
        );

        Date atTime = dateAt(2018, 0, 30, 10, 20, 15);

        assertEquals(
                dateAt(2018, 0, 30, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, QUARTER_CALENDAR_UNIT)
                ).getTime(atTime)
        );

        Date afterTime = dateAt(2018, 0, 30, 10, 20, 20);

        assertEquals(
                dateAt(2018, 4, 1, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, QUARTER_CALENDAR_UNIT)
                ).getTime(afterTime)
        );
    }

    @Test
    public void calculator_getTime_pastMonthlyNotifications_returnsNextMonthAtSameDate() {
        Date fireDate = dateAt(2017, 0, 15, 10, 20, 15);

        Date beforeTime = dateAt(2018, 1, 2, 8, 5, 2);

        assertEquals(
                dateAt(2018, 1, 15, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, MONTH_CALENDAR_UNIT)
                ).getTime(beforeTime)
        );

        Date atTime = dateAt(2018, 1, 15, 10, 20, 15);

        assertEquals(
                dateAt(2018, 1, 15, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, MONTH_CALENDAR_UNIT)
                ).getTime(atTime)
        );

        Date afterTime = dateAt(2018, 1, 15, 10, 20, 20);

        assertEquals(
                dateAt(2018, 2, 15, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, MONTH_CALENDAR_UNIT)
                ).getTime(afterTime)
        );
    }

    @Test
    public void calculator_getTime_pastMonthlyNotifications_returnsNextMonthAtSameDate_overflowCases() {
        Date fireDate = dateAt(2017, 0, 31, 10, 20, 15);

        Date beforeTime = dateAt(2018, 1, 2, 8, 5, 2);

        assertEquals(
                dateAt(2018, 1, 28, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, MONTH_CALENDAR_UNIT)
                ).getTime(beforeTime)
        );

        Date atTime = dateAt(2018, 1, 28, 10, 20, 15);

        assertEquals(
                dateAt(2018, 1, 28, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, MONTH_CALENDAR_UNIT)
                ).getTime(atTime)
        );

        Date afterTimeInMonth = dateAt(2018, 1, 28, 10, 20, 20);

        assertEquals(
                dateAt(2018, 2, 31, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, MONTH_CALENDAR_UNIT)
                ).getTime(afterTimeInMonth)
        );

        Date afterTime = dateAt(2018, 0, 31, 10, 20, 20);

        assertEquals(
                dateAt(2018, 1, 28, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, MONTH_CALENDAR_UNIT)
                ).getTime(afterTime)
        );
    }

    @Test
    public void calculator_getTime_pastYearlyNotifications_returnsNextYearAtSameMonthAndDate() {
        Date fireDate = dateAt(2017, 1, 15, 10, 20, 15);

        Date beforeTime = dateAt(2018, 0, 2, 8, 5, 2);

        assertEquals(
                dateAt(2018, 1, 15, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, YEAR_CALENDAR_UNIT)
                ).getTime(beforeTime)
        );

        Date atTime = dateAt(2018, 1, 15, 10, 20, 15);

        assertEquals(
                dateAt(2018, 1, 15, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, YEAR_CALENDAR_UNIT)
                ).getTime(atTime)
        );

        Date afterTime = dateAt(2018, 1, 15, 10, 20, 20);

        assertEquals(
                dateAt(2019, 1, 15, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, YEAR_CALENDAR_UNIT)
                ).getTime(afterTime)
        );
    }

    @Test
    public void calculator_getTime_pastYearlyNotifications_returnsNextYearAtSameMonthAndDate_overflowCases() {
        Date fireDate = dateAt(2016, 1, 29, 10, 20, 15);

        Date beforeTime = dateAt(2018, 1, 2, 8, 5, 2);

        assertEquals(
                dateAt(2018, 1, 28, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, YEAR_CALENDAR_UNIT)
                ).getTime(beforeTime)
        );

        Date atTime = dateAt(2018, 1, 28, 10, 20, 15);

        assertEquals(
                dateAt(2018, 1, 28, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, YEAR_CALENDAR_UNIT)
                ).getTime(atTime)
        );

        Date afterTimeInYear = dateAt(2019, 1, 28, 10, 20, 20);

        assertEquals(
                dateAt(2020, 1, 29, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, YEAR_CALENDAR_UNIT)
                ).getTime(afterTimeInYear)
        );

        Date afterTime = dateAt(2020, 1, 29, 10, 20, 20);

        assertEquals(
                dateAt(2021, 1, 28, 10, 20, 15).getTime(),
                getSubject(
                        notificationAt(fireDate, YEAR_CALENDAR_UNIT)
                ).getTime(afterTime)
        );
    }
}
