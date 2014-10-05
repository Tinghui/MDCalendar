//
//  NSDate+MDCalendar.m
//  MDCalendarDemo
//
//  Created by Michael Distefano on 5/23/14.
//  Copyright (c) 2014 Michael DiStefano
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "NSDate+MDCalendar.h"

@implementation NSDate (MDCalendar)

+ (NSInteger)numberOfDaysInMonth:(NSInteger)month forYear:(NSInteger)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [NSDateComponents new];
    [components setMonth:month];
    [components setYear:year];
    NSDate *date = [calendar dateFromComponents:components];
    
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    return range.length;
}

+ (NSDate *)dateFromComponents:(NSDateComponents *)components {
    return MDCalendarDateFromComponents(components);
}

+ (NSArray *)weekdays {
    return @[@"Sunday",
             @"Monday",
             @"Tuesday",
             @"Wednesday",
             @"Thursday",
             @"Friday",
             @"Saturday"];
}

+ (NSArray *)weekdayAbbreviations {
    //base on chinese
    return @[NSLocalizedString(@"日", nil),
             NSLocalizedString(@"一", nil),
             NSLocalizedString(@"二", nil),
             NSLocalizedString(@"三", nil),
             NSLocalizedString(@"四", nil),
             NSLocalizedString(@"五", nil),
             NSLocalizedString(@"六", nil)];
    
    //base on english
    return @[NSLocalizedString(@"SUN", nil),
             NSLocalizedString(@"MON", nil),
             NSLocalizedString(@"TUE", nil),
             NSLocalizedString(@"WED", nil),
             NSLocalizedString(@"THU", nil),
             NSLocalizedString(@"FRI", nil),
             NSLocalizedString(@"SAT", nil)];
}

+ (NSArray *)monthNames {
    //base on chinese
    return @[NSLocalizedString(@"零", nil),
             NSLocalizedString(@"1月", nil),
             NSLocalizedString(@"2月", nil),
             NSLocalizedString(@"3月", nil),
             NSLocalizedString(@"4月", nil),
             NSLocalizedString(@"5月", nil),
             NSLocalizedString(@"6月", nil),
             NSLocalizedString(@"7月", nil),
             NSLocalizedString(@"8月", nil),
             NSLocalizedString(@"9月", nil),
             NSLocalizedString(@"10月", nil),
             NSLocalizedString(@"11月", nil),
             NSLocalizedString(@"12月", nil)];
    //base on english
    return @[NSLocalizedString(@"Zero", nil),
             NSLocalizedString(@"January", nil),
             NSLocalizedString(@"February", nil),
             NSLocalizedString(@"March", nil),
             NSLocalizedString(@"April", nil),
             NSLocalizedString(@"May", nil),
             NSLocalizedString(@"June", nil),
             NSLocalizedString(@"July", nil),
             NSLocalizedString(@"August", nil),
             NSLocalizedString(@"September", nil),
             NSLocalizedString(@"October", nil),
             NSLocalizedString(@"November", nil),
             NSLocalizedString(@"December", nil)];
}

+ (NSArray *)shortMonthNames {
    //base on chinese
    return @[NSLocalizedString(@"零", nil),
             NSLocalizedString(@"1月", nil),
             NSLocalizedString(@"2月", nil),
             NSLocalizedString(@"3月", nil),
             NSLocalizedString(@"4月", nil),
             NSLocalizedString(@"5月", nil),
             NSLocalizedString(@"6月", nil),
             NSLocalizedString(@"7月", nil),
             NSLocalizedString(@"8月", nil),
             NSLocalizedString(@"9月", nil),
             NSLocalizedString(@"10月", nil),
             NSLocalizedString(@"11月", nil),
             NSLocalizedString(@"12月", nil)];
    //base on english
    return @[NSLocalizedString(@"Zero", nil),
             NSLocalizedString(@"Jan", nil),
             NSLocalizedString(@"Feb", nil),
             NSLocalizedString(@"Mar", nil),
             NSLocalizedString(@"Apr", nil),
             NSLocalizedString(@"May", nil),
             NSLocalizedString(@"Jun", nil),
             NSLocalizedString(@"Jul", nil),
             NSLocalizedString(@"Aug", nil),
             NSLocalizedString(@"Sep", nil),
             NSLocalizedString(@"Oct", nil),
             NSLocalizedString(@"Nov", nil),
             NSLocalizedString(@"Dec", nil)];
}

- (NSDate *)firstDayOfMonth {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    [components setDay:1];
    return MDCalendarDateFromComponents(components);
}

- (NSDate *)lastDayOfMonth {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    
    NSInteger month = [components month];
    [components setMonth:month+1];
    [components setDay:0];
    
    return MDCalendarDateFromComponents(components);
}

- (NSInteger)day {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    return [components day];
}

- (NSString *)dayOrdinalityString {
    return MDAppendOrdinalityToNumber([self day]);
}

- (NSString *)weekdayString {
    return [NSDate weekdays][self.weekday - 1];
}

- (NSInteger)weekday {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    return [components weekday];
}

- (NSInteger)month {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    return [components month];
}

- (NSString *)monthString {
    return [NSDate monthNames][[self month]];
}

- (NSString *)shortMonthString {
    return [NSDate shortMonthNames][[self month]];
}

- (NSInteger)year {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    return [components year];
}

- (NSDateComponents *)components {
    return MDCalendarDateComponentsFromDate(self);
}

- (NSInteger)numberOfDaysInMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *firstDayOfMonth = [self firstDayOfMonth];
    NSDate *lastDayOfMonth  = [self lastDayOfMonth];
    
    NSDateComponents *components = [calendar components:NSDayCalendarUnit fromDate:firstDayOfMonth toDate:lastDayOfMonth options:0];
    return [components day];
}

- (NSInteger)numberOfMonthsUntilEndDate:(NSDate *)endDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self toDate:endDate options:0];

    return [components month];
}

- (NSInteger)numberOfDaysUntilEndDate:(NSDate *)endDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self toDate:endDate options:0];
    return [components day];
}

- (NSDate *)dateByAddingDays:(NSInteger)days {
    
    NSDateComponents *components = [NSDateComponents new];
    components.day = days;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months {
    NSDateComponents *components = [NSDateComponents new];
    components.month = months;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (BOOL)isEqualToDateSansTime:(NSDate *)otherDate {
    if (self.day == otherDate.day &&
        self.month == otherDate.month &&
        self.year == otherDate.year) {
        return YES;
    }
    return NO;
}

- (BOOL)isBeforeDate:(NSDate *)otherDate {
    return [self compare:otherDate] == NSOrderedAscending;
}

- (BOOL)isAfterDate:(NSDate *)otherDate {
    return [self compare:otherDate] == NSOrderedDescending;
}


#pragma mark - Helpers
                  
NSDateComponents * MDCalendarDateComponentsFromDate(NSDate *date) {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSYearCalendarUnit|NSCalendarUnitMonth|NSWeekCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:date];
}

NSDate * MDCalendarDateFromComponents(NSDateComponents *components) {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateFromComponents:components];
}

NSString * MDAppendOrdinalityToNumber(NSInteger number) {
    NSString *ordinalityString = @"";
    NSInteger lastDigit = number % 10;
    
    NSString * (^appendOrdinalityBlock)(NSString *ordinality) = ^NSString *(NSString *ordinality){
        return [NSString stringWithFormat:@"%d%@", (int)number, ordinality];
    };
    
    if (number > 10 && number < 20) {
        ordinalityString = appendOrdinalityBlock(@"th");
    } else if (lastDigit == 0) {
        ordinalityString = appendOrdinalityBlock(@"th");
    } else if (lastDigit == 1) {
        ordinalityString = appendOrdinalityBlock(@"st");
    } else if (lastDigit == 2) {
        ordinalityString = appendOrdinalityBlock(@"nd");
    } else if (lastDigit == 3) {
        ordinalityString = appendOrdinalityBlock(@"rd");
    } else {
        ordinalityString = appendOrdinalityBlock(@"th");
    }
    
    return ordinalityString;
}

@end
