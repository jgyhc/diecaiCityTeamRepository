//
//  NSDate+NTAdd.m
//  CatergoryDemo
//
//  Created by wazrx on 16/5/13.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "NSDate+NTAdd.h"
#import "NTCategoriesMacro.h"

NT_SYNTH_DUMMY_CLASS(NSDate_NTAdd)

static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);

@implementation NSDate (NTAdd)

+ (NSCalendar *)nt_currentCalendar
{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}

- (NSDate *)startDate{
    NSDateComponents *components = [[NSDate nt_currentCalendar] components:componentFlags fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSDate nt_currentCalendar] dateFromComponents:components];
}

- (NSDate *)endDate{
    NSDateComponents *components = [[NSDate nt_currentCalendar] components:componentFlags fromDate:self];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [[NSDate nt_currentCalendar] dateFromComponents:components];
}

- (NSInteger)year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)nanosecond {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

- (NSInteger)weekday {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)weekdayOrdinal {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)weekOfMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)weekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)yearForWeekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

- (NSInteger)quarter {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

- (BOOL)isLeapMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

- (BOOL)isLeapYear {
    NSUInteger year = self.year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate new].day == self.day;
}

- (BOOL)isYesterday {
    NSDate *added = [self nt_dateByAddingDays:1];
    return [added isToday];
}

- (BOOL)isTomorrow{
    return [self nt_isEqualToDateIgnoringTime:[NSDate nt_dateTomorrow]];
}

- (BOOL)isThisWeek{
    return [self nt_isSameWeekAsDate:[NSDate date]];
    
}

- (BOOL)isNextWeek{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self nt_isSameWeekAsDate:newDate];
    
}

- (BOOL)isLastWeek{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self nt_isSameWeekAsDate:newDate];
    
}

- (BOOL)isThisMonth{
    return [self nt_isSameMonthAsDate:[NSDate date]];
    
}

- (BOOL)isNextMonth{
    return [self nt_isSameMonthAsDate:[[NSDate date] nt_dateByAddingMonths:1]];
    
}

- (BOOL)isLastMonth{
    return [self nt_isSameMonthAsDate:[[NSDate date] nt_dateBySubtractingMonths:1]];
    
}

- (BOOL)isThisYear{
    return [self nt_isSameYearAsDate:[NSDate date]];
}

- (BOOL)isNextYear{
    NSDateComponents *components1 = [[NSDate nt_currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate nt_currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    return (components1.year == (components2.year + 1));
    
}

- (BOOL)isLastYear{
    NSDateComponents *components1 = [[NSDate nt_currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate nt_currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    return (components1.year == (components2.year - 1));
}

- (BOOL)isInFuture{
    return ([self nt_isLaterThanDate:[NSDate date]]);
}

-(BOOL)isInPast{
    return ([self nt_isEarlierThanDate:[NSDate date]]);
}

- (BOOL)isWorkday{
    NSDateComponents *components = [[NSDate nt_currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL)isWeekend{
    return !self.isWorkday;
}

- (BOOL)nt_isEqualToDateIgnoringTime: (NSDate *) aDate{
    NSDateComponents *components1 = [[NSDate nt_currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate nt_currentCalendar] components:componentFlags fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL)nt_isSameWeekAsDate: (NSDate *) aDate{
    NSDateComponents *components1 = [[NSDate nt_currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate nt_currentCalendar] components:componentFlags fromDate:aDate];
    
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.weekOfMonth != components2.weekOfMonth) return NO;
    
    // Must have a time interval under 1 week. Thanks @aclark
    return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL)nt_isSameMonthAsDate: (NSDate *) aDate{
    NSDateComponents *components1 = [[NSDate nt_currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [[NSDate nt_currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL)nt_isSameYearAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate nt_currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate nt_currentCalendar] components:NSCalendarUnitYear fromDate:aDate];
    return (components1.year == components2.year);
}

- (BOOL)nt_isSameDayAsDate:(NSDate *)aDate{
    NSDateComponents *components1 = [[NSDate nt_currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSDateComponents *components2 = [[NSDate nt_currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year) && (components1.day == components2.day));
}

- (BOOL)nt_isEarlierThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL)nt_isLaterThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

- (NSDate *)nt_dateByAddingYears:(NSInteger)dYears {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:dYears];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)nt_dateBySubtractingYears: (NSInteger) dYears {
    return [self nt_dateByAddingYears:-dYears];
}

- (NSDate *)nt_dateByAddingMonths: (NSInteger) dMonths {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:dMonths];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)nt_dateBySubtractingMonths: (NSInteger) dMonths {
    return [self nt_dateByAddingMonths:-dMonths];
}

- (NSDate *)nt_dateByAddingDays: (NSInteger) dDays {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)nt_dateBySubtractingDays: (NSInteger) dDays {
    return [self nt_dateByAddingDays: (dDays * -1)];
	
}

- (NSDate *)nt_dateByAddingHours: (NSInteger) dHours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
	
}

- (NSDate *)nt_dateBySubtractingHours: (NSInteger) dHours {
    return [self nt_dateByAddingHours: (dHours * -1)];
}

- (NSDate *)nt_dateByAddingMinutes: (NSInteger) dMinutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)nt_dateBySubtractingMinutes: (NSInteger) dMinutes {
    return [self nt_dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *)nt_dateAtStartOfDay {
    NSDateComponents *components = [[NSDate nt_currentCalendar] components:componentFlags fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSDate nt_currentCalendar] dateFromComponents:components];
}

- (NSDate *)nt_dateAtEndOfDay {
    NSDateComponents *components = [[NSDate nt_currentCalendar] components:componentFlags fromDate:self];
    components.hour = 23; // Thanks Aleksey Kononov
    components.minute = 59;
    components.second = 59;
    return [[NSDate nt_currentCalendar] dateFromComponents:components];
}

- (NSInteger)nt_minutesAfterDate: (NSDate *)aDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger)nt_minutesBeforeDate: (NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger)nt_hoursAfterDate: (NSDate *)aDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger)nt_hoursBeforeDate: (NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger)nt_daysAfterDate: (NSDate *)aDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_DAY);
}

- (NSInteger)nt_daysBeforeDate: (NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_DAY);
}

- (NSInteger)nt_distanceInDaysToDate:(NSDate *)anotherDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    return components.day;
}

+ (NSDate *)nt_dateWithDaysFromNow: (NSInteger) days {
    return [[NSDate date] nt_dateByAddingDays:days];
}

+ (NSDate *)nt_dateWithDaysBeforeNow: (NSInteger) days {
    return [[NSDate date] nt_dateBySubtractingDays:days];
}

+ (NSDate *)nt_dateWithHoursFromNow: (NSInteger) dHours {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)nt_dateWithHoursBeforeNow: (NSInteger) dHours {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)nt_dateWithMinutesFromNow: (NSInteger) dMinutes {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)nt_dateWithMinutesBeforeNow: (NSInteger) dMinutes {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)nt_dateTomorrow {
    return [NSDate nt_dateWithDaysFromNow:1];
}

+ (NSDate *)nt_dateYesterday {
    return [NSDate nt_dateWithDaysBeforeNow:1];
}

- (NSString *)nt_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

- (NSString *)nt_stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter stringFromDate:self];
	
}

+ (NSDate *)nt_dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
	
}

+ (NSDate *)nt_dateWithString:(NSString *)dateString format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter dateFromString:dateString];
	
}

+ (NSDate *)nt_dateWithTimestamp:(NSString *)timestamp {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    return confromTimesp;
	
}

+ (BOOL)nt_checkSystemTimeFormatterIs12HourType {
    static BOOL flag = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
        NSRange containsA = [formatStringForHours rangeOfString:@"a"];
        flag = containsA.location != NSNotFound;
        
    });
    return flag;
}

+ (NSDate *)nt_dateForSystem {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

- (BOOL)nt_isNightAtTimezone:(NSString *)timezone{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = timezone.length ? [NSTimeZone timeZoneWithName:timezone] : [NSTimeZone systemTimeZone];
    NSUInteger hour =[calendar components:NSCalendarUnitHour fromDate:self].hour;
    return hour > 18;
}


@end
