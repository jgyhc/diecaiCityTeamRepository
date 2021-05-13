//
//  NSDate+NTAdd.h
//  CatergoryDemo
//
//  Created by wazrx on 16/5/13.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <Foundation/Foundation.h>
#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDate (NTAdd)

NS_ASSUME_NONNULL_BEGIN

#pragma mark - fast property

@property (nonatomic, readonly) NSDate *startDate;
@property (nonatomic, readonly) NSDate *endDate;
@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger day;
@property (nonatomic, readonly) NSInteger hour;
@property (nonatomic, readonly) NSInteger minute;
@property (nonatomic, readonly) NSInteger second;
@property (nonatomic, readonly) NSInteger nanosecond;
@property (nonatomic, readonly) NSInteger weekday;
@property (nonatomic, readonly) NSInteger weekdayOrdinal;
@property (nonatomic, readonly) NSInteger weekOfMonth;
@property (nonatomic, readonly) NSInteger weekOfYear;
@property (nonatomic, readonly) NSInteger yearForWeekOfYear;
@property (nonatomic, readonly) NSInteger quarter;
@property (nonatomic, readonly) BOOL isLeapMonth;
@property (nonatomic, readonly) BOOL isLeapYear;
@property (nonatomic, readonly) BOOL isToday;
@property (nonatomic, readonly) BOOL isYesterday;
@property (nonatomic, readonly) BOOL isTomorrow; 
@property (nonatomic, readonly) BOOL isThisWeek; 
@property (nonatomic, readonly) BOOL isNextWeek; 
@property (nonatomic, readonly) BOOL isLastWeek; 
@property (nonatomic, readonly) BOOL isThisMonth; 
@property (nonatomic, readonly) BOOL isNextMonth; 
@property (nonatomic, readonly) BOOL isLastMonth; 
@property (nonatomic, readonly) BOOL isThisYear; 
@property (nonatomic, readonly) BOOL isNextYear; 
@property (nonatomic, readonly) BOOL isLastYear; 
@property (nonatomic, readonly) BOOL isInFuture; 
@property (nonatomic, readonly) BOOL isInPast; 
@property (nonatomic, readonly) BOOL isWorkday;
@property (nonatomic, readonly) BOOL isWeekend;

/**获取系统时区时间*/
+ (NSDate *)nt_dateForSystem;

#pragma mark - date Change(时间增减相关)

- (NSDate *)nt_dateByAddingYears: (NSInteger) dYears;
- (NSDate *)nt_dateBySubtractingYears: (NSInteger) dYears;
- (NSDate *)nt_dateByAddingMonths: (NSInteger) dMonths;
- (NSDate *)nt_dateBySubtractingMonths: (NSInteger) dMonths;
- (NSDate *)nt_dateByAddingDays: (NSInteger) dDays;
- (NSDate *)nt_dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *)nt_dateByAddingHours: (NSInteger) dHours;
- (NSDate *)nt_dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *)nt_dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *)nt_dateBySubtractingMinutes: (NSInteger) dMinutes;
+ (NSDate *)nt_dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *)nt_dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *)nt_dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *)nt_dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *)nt_dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *)nt_dateWithMinutesBeforeNow: (NSInteger) dMinutes;
+ (NSDate *)nt_dateTomorrow;
+ (NSDate *)nt_dateYesterday;

#pragma mark - date intervals(获取时间间隔相关)

- (NSInteger)nt_minutesAfterDate: (NSDate *)aDate;
- (NSInteger)nt_minutesBeforeDate: (NSDate *)aDate;
- (NSInteger)nt_hoursAfterDate: (NSDate *)aDate;
- (NSInteger)nt_hoursBeforeDate: (NSDate *)aDate;
- (NSInteger)nt_daysAfterDate: (NSDate *)aDate;
- (NSInteger)nt_daysBeforeDate: (NSDate *)aDate;
- (NSInteger)nt_distanceInDaysToDate:(NSDate *)anotherDate;

#pragma mark - equal(时间比较相关)

- (BOOL)nt_isSameWeekAsDate: (NSDate *) aDate;
- (BOOL)nt_isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL)nt_isSameMonthAsDate: (NSDate *) aDate;
- (BOOL)nt_isSameDayAsDate: (NSDate *) aDate;
- (BOOL)nt_isSameYearAsDate: (NSDate *) aDate;
- (BOOL)nt_isEarlierThanDate: (NSDate *) aDate;
- (BOOL)nt_isLaterThanDate: (NSDate *) aDate;

#pragma mark - date Format (时间格式相关)

- (NSString *)nt_stringWithFormat:(NSString *)format;

- (NSString *)nt_stringWithFormat:(NSString *)format
                               timeZone:(NSTimeZone *)timeZone
                                 locale:(nullable NSLocale *)locale;

+ (NSDate *)nt_dateWithString:(NSString *)dateString format:(NSString *)format;

+ (NSDate *)nt_dateWithString:(NSString *)dateString
                             format:(NSString *)format
                           timeZone:(NSTimeZone *)timeZone
                             locale:(nullable NSLocale *)locale;

#pragma mark - timeStamp (时间戳相关)

+ (NSDate *)nt_dateWithTimestamp:(NSString *)timestamp;

#pragma mark - other

/**判断是否是12小时格式*/
+ (BOOL)nt_checkSystemTimeFormatterIs12HourType;

- (BOOL)nt_isNightAtTimezone:(NSString *)timezone;


@end

NS_ASSUME_NONNULL_END
