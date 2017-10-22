package com.juankpro.ane.localnotif;

/**
 * Created by Juank on 10/21/17.
 */

class NotificationTimeInterval {
    /**
     * Represents a second in milliseconds
     */
    private final static long SECOND_CALENDAR_UNIT_MS = 1000;
    /**
     * Represents a minute in milliseconds
     */
    private final static long MINUTE_CALENDAR_UNIT_MS = SECOND_CALENDAR_UNIT_MS * 60;
    /**
     * Represents a week in milliseconds
     */
    private final static long HOUR_CALENDAR_UNIT_MS = MINUTE_CALENDAR_UNIT_MS * 60;
    /**
     * Represents a day in milliseconds
     */
    private final static long DAY_CALENDAR_UNIT_MS = HOUR_CALENDAR_UNIT_MS * 24;
    /**
     * Represents a month in milliseconds
     * Not exact
     */
    private final static long MONTH_CALENDAR_UNIT_MS = DAY_CALENDAR_UNIT_MS * 30;
    /**
     * Represents a year in milliseconds
     * Not exact
     */
    private final static long YEAR_CALENDAR_UNIT_MS = DAY_CALENDAR_UNIT_MS * 365;
    /**
     * Represents week in milliseconds
     */
    private final static long WEEK_CALENDAR_UNIT_MS = DAY_CALENDAR_UNIT_MS * 7;
    /**
     * Represents a quarter year in milliseconds
     * Not exact
     */
    private final static long QUARTER_CALENDAR_UNIT_MS = YEAR_CALENDAR_UNIT_MS / 4;


    /**
     * Represents a year repeat interval
     */
    private final static int YEAR_CALENDAR_UNIT = 1 << 2;
    /**
     * Represents a month repeat interval
     */
    private final static int MONTH_CALENDAR_UNIT = 1 << 3;
    /**
     * Represents a day repeat interval
     */
    private final static int DAY_CALENDAR_UNIT = 1 << 4;
    /**
     * Represents an hour repeat interval
     */
    private final static int HOUR_CALENDAR_UNIT = 1 << 5;
    /**
     * Represents a minute repeat interval
     */
    private final static int MINUTE_CALENDAR_UNIT = 1 << 6;
    /**
     * Represents a second repeat interval
     */
    private final static int SECOND_CALENDAR_UNIT = 1 << 7;
    /**
     * Represents a week repeat interval
     */
    private final static int WEEK_CALENDAR_UNIT = 1 << 13;
    /**
     * Represents a quarter year repeat interval
     */
    private final static int QUARTER_CALENDAR_UNIT = 1 << 11;

    static private long mapIntervalToMilliseconds(int interval) {
        switch (interval) {
            case YEAR_CALENDAR_UNIT:
                return YEAR_CALENDAR_UNIT_MS;
            case MONTH_CALENDAR_UNIT:
                return MONTH_CALENDAR_UNIT_MS;
            case DAY_CALENDAR_UNIT:
                return DAY_CALENDAR_UNIT_MS;
            case HOUR_CALENDAR_UNIT:
                return HOUR_CALENDAR_UNIT_MS;
            case MINUTE_CALENDAR_UNIT:
                return MINUTE_CALENDAR_UNIT_MS;
            case SECOND_CALENDAR_UNIT:
                return SECOND_CALENDAR_UNIT_MS;
            case WEEK_CALENDAR_UNIT:
                return WEEK_CALENDAR_UNIT_MS;
            case QUARTER_CALENDAR_UNIT:
                return QUARTER_CALENDAR_UNIT_MS;
            default:
                return 0;
        }
    }

    private int intervalId;

    NotificationTimeInterval(int intervalId) {
        this.intervalId = intervalId;
    }

    long toMilliseconds() {
        return mapIntervalToMilliseconds(this.intervalId);
    }
}
