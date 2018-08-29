package com.juankpro.ane.localnotif.util;

import com.juankpro.ane.localnotif.LocalNotification;
import com.juankpro.ane.localnotif.LocalNotificationTimeInterval;

import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import static com.juankpro.ane.localnotif.LocalNotificationTimeInterval.MONTH_CALENDAR_UNIT;
import static com.juankpro.ane.localnotif.LocalNotificationTimeInterval.YEAR_CALENDAR_UNIT;

import static com.juankpro.ane.localnotif.LocalNotificationTimeInterval.DAY_CALENDAR_UNIT;
import static com.juankpro.ane.localnotif.LocalNotificationTimeInterval.HOUR_CALENDAR_UNIT;
import static com.juankpro.ane.localnotif.LocalNotificationTimeInterval.MINUTE_CALENDAR_UNIT;
import static com.juankpro.ane.localnotif.LocalNotificationTimeInterval.SECOND_CALENDAR_UNIT;
import static com.juankpro.ane.localnotif.LocalNotificationTimeInterval.MILLISECOND_CALENDAR_UNIT;

public class NextNotificationCalculator {
    private LocalNotification notification;

    public NextNotificationCalculator(LocalNotification notification) {
        this.notification = notification;
    }

    public Date getDate(Date now) {
        return new Date(getTime(now));
    }

    public long getTime(Date now) {
        long interval = notification.getRepeatIntervalMilliseconds();
        long notificationTime = getNotificationTime();
        long curTime = now.getTime();

        if (interval == 0 || notificationTime >= curTime) return notificationTime;

        if (notification.repeatInterval == MONTH_CALENDAR_UNIT) {
            return getTime(Calendar.MONTH, now);
        }

        if (notification.repeatInterval == YEAR_CALENDAR_UNIT) {
            return getTime(Calendar.YEAR, now);
        }

        long elapsedTime = curTime - notificationTime;
        long triggerCount = (long)Math.ceil(elapsedTime / (double)interval);
        return notificationTime + interval * triggerCount;
    }

    private long getTimeOfMonth(Calendar calendar) {
        return getTimeOfMonth(calendar, Integer.MAX_VALUE);
    }

    private long getTimeOfMonth(Calendar calendar, int maxDay) {
        int[][] intervalUnits = new int[][] {
                new int[] {DAY_CALENDAR_UNIT, Math.min(maxDay, calendar.get(Calendar.DAY_OF_MONTH))},
                new int[] {HOUR_CALENDAR_UNIT, calendar.get(Calendar.HOUR_OF_DAY)},
                new int[] {MINUTE_CALENDAR_UNIT, calendar.get(Calendar.MINUTE)},
                new int[] {SECOND_CALENDAR_UNIT, calendar.get(Calendar.SECOND)},
                new int[] {MILLISECOND_CALENDAR_UNIT, calendar.get(Calendar.MILLISECOND)}
        };

        long timeMillis = 0;
        for (int[] intervalUnit : intervalUnits) {
            timeMillis += new LocalNotificationTimeInterval(intervalUnit[0]).toMilliseconds(intervalUnit[1]);
        }

        return timeMillis;
    }

    private long getTime(int field, Date now) {
        Calendar curCalendar = (Calendar) GregorianCalendar.getInstance().clone();
        curCalendar.setTime(now);

        Calendar fireDateCalendar = (Calendar) GregorianCalendar.getInstance().clone();
        fireDateCalendar.setTime(notification.fireDate);

        Calendar resultCalendar = (Calendar) curCalendar.clone();
        resultCalendar.set(Calendar.DAY_OF_MONTH, 1); // prevent month roll when setting month
        resultCalendar.set(Calendar.HOUR_OF_DAY, fireDateCalendar.get(Calendar.HOUR_OF_DAY));
        resultCalendar.set(Calendar.MINUTE, fireDateCalendar.get(Calendar.MINUTE));
        resultCalendar.set(Calendar.SECOND, fireDateCalendar.get(Calendar.SECOND));
        resultCalendar.set(Calendar.MILLISECOND, fireDateCalendar.get(Calendar.MILLISECOND));

        if (field == Calendar.YEAR) {
            resultCalendar.set(Calendar.MONTH, fireDateCalendar.get(Calendar.MONTH));
        }

        if (shouldRollYear(field, curCalendar, fireDateCalendar)) {
            resultCalendar.roll(Calendar.YEAR, 1);
        }

        if (shouldRollMonth(field, curCalendar, fireDateCalendar)) {
            resultCalendar.roll(Calendar.MONTH, 1);
        }

        int resultDayOfMonth = Math.min(
                resultCalendar.getActualMaximum(Calendar.DAY_OF_MONTH),
                fireDateCalendar.get(Calendar.DAY_OF_MONTH)
        );

        resultCalendar.set(Calendar.DAY_OF_MONTH, resultDayOfMonth);

        return resultCalendar.getTimeInMillis();
    }

    private boolean shouldRollYear(int field, Calendar curCalendar, Calendar fireDateCalendar) {
        return field == Calendar.YEAR && isTimeOfYearGreaterThan(curCalendar, fireDateCalendar);
    }

    private boolean shouldRollMonth(int field, Calendar curCalendar, Calendar fireDateCalendar) {
        return field == Calendar.MONTH && isTimeOfMonthGreaterThan(curCalendar, fireDateCalendar);
    }

    private boolean isTimeOfYearGreaterThan(Calendar curCalendar, Calendar fireDateCalendar) {
        int fireMonth = fireDateCalendar.get(Calendar.MONTH);
        int curMonth = curCalendar.get(Calendar.MONTH);
        boolean timeOfMonthGreaterThan = isTimeOfMonthGreaterThan(curCalendar, fireDateCalendar);
        return curMonth > fireMonth || (curMonth == fireMonth && timeOfMonthGreaterThan);
    }

    private boolean isTimeOfMonthGreaterThan(Calendar curCalendar, Calendar fireCalendar) {
        long fireTimeOfMonth =
                getTimeOfMonth(fireCalendar, curCalendar.getActualMaximum(Calendar.DAY_OF_MONTH));
        long curTimeOfMonth = getTimeOfMonth(curCalendar);
        return curTimeOfMonth > fireTimeOfMonth;
    }

    private long getNotificationTime() {
        return notification.fireDate.getTime();
    }
}
