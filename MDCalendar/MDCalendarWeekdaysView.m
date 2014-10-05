//
//  MDCalendarWeekdaysView.m
//  MDCalendarDemo
//
//  Created by ZhangTinghui on 14-9-22.
//  Copyright (c) 2014年 ZhangTinghui. All rights reserved.
//

#import "MDCalendarWeekdaysView.h"
#import "NSDate+MDCalendar.h"

@implementation MDCalendarWeekdaysView

@synthesize font = pFont;

+ (CGFloat)preferredHeightWithFont:(UIFont *)font {
    static CGFloat height;
    static dispatch_once_t onceTokenForWeekdayViewHeight;
    dispatch_once(&onceTokenForWeekdayViewHeight, ^{
        NSString *day = [[NSDate weekdayAbbreviations] firstObject];
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        dayLabel.text = day;
        dayLabel.font = font;
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.adjustsFontSizeToFitWidth = YES;
        height = [dayLabel sizeThatFits:CGSizeZero].height;
    });
    return height;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *weekdays = [NSDate weekdayAbbreviations];
        NSMutableArray *dayLabels = [NSMutableArray new];
        for (NSString *day in weekdays) {
            UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            dayLabel.text = day;
            dayLabel.font = self.font;
            dayLabel.textAlignment = NSTextAlignmentCenter;
            dayLabel.adjustsFontSizeToFitWidth = YES;
            [dayLabels addObject:dayLabel];
            
            [self addSubview:dayLabel];
            
            self.isAccessibilityElement = YES;
        }
        
        self.dayLabels = dayLabels;
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    return CGSizeMake(viewWidth, [MDCalendarWeekdaysView preferredHeightWithFont:self.font]);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat labelWidth = CGRectGetWidth(self.bounds) / [_dayLabels count];
    CGRect labelFrame = CGRectMake(0, 0, labelWidth, [MDCalendarWeekdaysView preferredHeightWithFont:self.font]);
    for (UILabel *label in _dayLabels) {
        label.frame = labelFrame;
        labelFrame = CGRectOffset(labelFrame, labelWidth, 0);
    }
}

- (void)setTextColor:(UIColor *)textColor {
    for (UILabel *label in _dayLabels) {
        label.textColor = textColor;
    }
}

- (void)setFont:(UIFont *)font {
    for (UILabel *label in _dayLabels) {
        label.font = font;
    }
}

#pragma mark - UIAccessibility

- (NSString *)accessibilityLabel {
    return [NSString stringWithFormat:@"Weekdays, %@ through %@", [NSDate weekdays].firstObject, [NSDate weekdays].lastObject];
}

@end

