//
//  JKCalendarUnit.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/1/17.
//
//

#ifndef JKCalendarUnit_h
#define JKCalendarUnit_h

typedef CF_OPTIONS(CFOptionFlags, JKCalendarUnit) {
    JKCalendarUnitNone = 0,
    JKCalendarUnitEra = (1UL << 1),
    JKCalendarUnitYear = (1UL << 2),
    JKCalendarUnitMonth = (1UL << 3),
    JKCalendarUnitDay = (1UL << 4),
    JKCalendarUnitHour = (1UL << 5),
    JKCalendarUnitMinute = (1UL << 6),
    JKCalendarUnitSecond = (1UL << 7),
    JKCalendarUnitWeekday = (1UL << 9),
    JKCalendarUnitWeekdayOrdinal = (1UL << 10),
    JKCalendarUnitQuarter NS_ENUM_AVAILABLE(10_6, 4_0) = (1UL << 11),
    JKCalendarUnitWeekOfMonth NS_ENUM_AVAILABLE(10_7, 5_0) = (1UL << 12),
    JKCalendarUnitWeekOfYear NS_ENUM_AVAILABLE(10_7, 5_0) = (1UL << 13),
    JKCalendarUnitYearForWeekOfYear NS_ENUM_AVAILABLE(10_7, 5_0) = (1UL << 14),

    JKCalendarUnitNanosecond NS_ENUM_AVAILABLE(10_7, 5_0) = (1 << 15),
    JKCalendarUnitCalendar NS_ENUM_AVAILABLE(10_7, 4_0) = (1 << 20),
    JKCalendarUnitTimeZone NS_ENUM_AVAILABLE(10_7, 4_0) = (1 << 21),
};


#endif /* JKCalendarUnit_h */
