// Copyright DApps Platform Inc. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSDate (MLCatrgory)

+ (NSCalendar *) currentCalendar;
+ (NSDate *)convertDateToLocalTime: (NSDate *)forDate;

#pragma mark - 相对日期
+ (NSDate *) dateNow;
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;

#pragma mark - 日期转字符串
- (NSString *) stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle;
- (NSString *) stringWithFormat: (NSString *) format;
    @property (nonatomic, readonly) NSString *shortString;
    @property (nonatomic, readonly) NSString *shortDateString;
    @property (nonatomic, readonly) NSString *shortTimeString;
    @property (nonatomic, readonly) NSString *mediumString;
    @property (nonatomic, readonly) NSString *mediumDateString;
    @property (nonatomic, readonly) NSString *mediumTimeString;
    @property (nonatomic, readonly) NSString *longString;
    @property (nonatomic, readonly) NSString *longDateString;
    @property (nonatomic, readonly) NSString *longTimeString;

#pragma mark - 日期比较
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;

- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;

- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;

- (BOOL) isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) isThisMonth;
- (BOOL) isNextMonth;
- (BOOL) isLastMonth;

- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;

- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;

- (BOOL) isInFuture;
- (BOOL) isInPast;

#pragma mark - 日期规则
- (BOOL) isTypicallyWorkday;
- (BOOL) isTypicallyWeekend;

#pragma mark - 调整日期
- (NSDate *) dateByAddingYears: (NSInteger) dYears;
- (NSDate *) dateBySubtractingYears: (NSInteger) dYears;
- (NSDate *) dateByAddingMonths: (NSInteger) dMonths;
- (NSDate *) dateBySubtractingMonths: (NSInteger) dMonths;
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;

#pragma mark - 极端日期
- (NSDate *) dateAtStartOfDay;
- (NSDate *) dateAtEndOfDay;

#pragma mark - 日期间隔
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;
- (NSInteger) distanceInDaysToDate:(NSDate *)anotherDate;

#pragma mark - 分解日期
    @property (readonly) NSInteger nearestHour;
    @property (readonly) NSInteger hour;
    @property (readonly) NSInteger minute;
    @property (readonly) NSInteger seconds;
    @property (readonly) NSInteger day;
    @property (readonly) NSInteger month;
    @property (readonly) NSInteger weekOfMonth;
    @property (readonly) NSInteger weekOfYear;
    @property (readonly) NSInteger weekday;
    @property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
    @property (readonly) NSInteger year;
- (void)getCurrentWeek;
-(NSMutableArray *)latelyEightTime;
-(NSMutableArray *)latelyEightTimeInt;
@end
