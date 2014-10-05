//
//  MDCalendarHeaderView.m
//  MDCalendarDemo
//
//  Created by ZhangTinghui on 14-9-22.
//  Copyright (c) 2014年 ZhangTinghui. All rights reserved.
//

#import "MDCalendarHeaderView.h"
#import "NSDate+MDCalendar.h"

@implementation MDCalendarHeaderView

+ (CGFloat)preferredHeightWithMonthLabelFont:(UIFont *)monthFont
{
    static CGFloat headerHeight;
    static dispatch_once_t onceTokenForHeaderViewHeight;
    dispatch_once(&onceTokenForHeaderViewHeight, ^{
        CGFloat monthLabelHeight = [self heightForMonthLabelWithFont:monthFont];
        headerHeight = monthLabelHeight;
    });
    
    return headerHeight;
}

+ (CGFloat)heightForMonthLabelWithFont:(UIFont *)font
{
    static CGFloat monthLabelHeight;
    static dispatch_once_t onceTokenForMonthLabelHeight;
    
    dispatch_once(&onceTokenForMonthLabelHeight, ^{
        UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        monthLabel.textAlignment = NSTextAlignmentCenter;
        monthLabel.font = font;
        monthLabel.text = [[NSDate date] monthString];  // using current month as an example string
        monthLabelHeight = [monthLabel sizeThatFits:CGSizeZero].height;
    });
    
    return monthLabelHeight;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)setLabelInset:(UIEdgeInsets)labelInset
{
    if (UIEdgeInsetsEqualToEdgeInsets(_labelInset, labelInset)) {
        return;
    }
    
    _labelInset = labelInset;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize viewSize = self.bounds.size;
    _label.frame = CGRectMake(self.labelInset.left, self.labelInset.top,
                              viewSize.width - self.labelInset.left - self.labelInset.right,
                              viewSize.height - self.labelInset.top - self.labelInset.bottom);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    static BOOL firstTime = YES;
    static CGSize calendarHeaderViewSize;
    if (firstTime) {
        calendarHeaderViewSize = CGSizeMake([super sizeThatFits:size].width, [MDCalendarHeaderView preferredHeightWithMonthLabelFont:self.font]);
    }
    
    return calendarHeaderViewSize;
}

- (void)setFirstDayOfMonth:(NSDate *)firstDayOfMonth
{
    _firstDayOfMonth = firstDayOfMonth;
    _label.text =  [firstDayOfMonth monthString];
}

- (void)setFont:(UIFont *)font
{
    _label.font = font;
    _label.minimumScaleFactor = 0.5;
}

- (void)setTextColor:(UIColor *)textColor
{
    _label.textColor = textColor;
}
@end
