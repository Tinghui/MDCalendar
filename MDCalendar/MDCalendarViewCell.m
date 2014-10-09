//
//  MDCalendarViewCell.m
//  MDCalendarDemo
//
//  Created by ZhangTinghui on 14-9-22.
//  Copyright (c) 2014年 ZhangTinghui. All rights reserved.
//

#import "NSDate+MDCalendar.h"
#import "MDCalendarViewCell.h"

@interface MDCalendarViewCell  ()

@end

@implementation MDCalendarViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        self.label = label;
        
        UIView *highlightView = [[UIView alloc] initWithFrame:CGRectZero];
        highlightView.hidden = YES;
        self.highlightView = highlightView;
        
        UIView *topBorderView = [[UIView alloc] initWithFrame:CGRectZero];
        topBorderView.hidden = YES;
        self.topBorderView = topBorderView;
        
        UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectZero];
        indicatorView.hidden = YES;
        self.indicatorView = indicatorView;
        
        [self.contentView addSubview:highlightView];
        [self.contentView addSubview:label];
        [self.contentView addSubview:topBorderView];
        [self.contentView addSubview:indicatorView];
        
        self.isAccessibilityElement = YES;
    }
    
    return self;
}

- (void)setDate:(NSDate *)date
{
    _label.text = MDCalendarDayStringFromDate(date);
    
    self.accessibilityLabel = [NSString stringWithFormat:@"%@, %@ of %@ %@", [date weekdayString], [date dayOrdinalityString], [date monthString], @([date year])];
}

- (void)setFont:(UIFont *)font
{
    _label.font = font;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _label.textColor = textColor;
}

- (void)setHighlightColor:(UIColor *)highlightColor
{
    _highlightView.backgroundColor = highlightColor;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _topBorderView.backgroundColor = borderColor;
    _topBorderView.hidden = NO;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorView.backgroundColor = indicatorColor;
    _indicatorView.hidden = NO;
}

- (void)setSelected:(BOOL)selected
{
    UIView *highlightView = _highlightView;
    highlightView.hidden = !selected;
    _label.textColor = selected ? self.backgroundColor : _textColor;
    
    [super setSelected:selected];
}

- (void)playSelectionAnimation
{
    UIView *highlightView = _highlightView;
    highlightView.transform = CGAffineTransformMakeScale(.1f, .1f);
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         highlightView.transform = CGAffineTransformIdentity;
                     } completion:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize viewSize = self.contentView.bounds.size;
    
    //topBorder
    _topBorderView.frame = CGRectMake(0, 0, viewSize.width, _borderHeight);
    
    //label
    _label.frame = CGRectMake(0, _borderHeight, viewSize.width, viewSize.height - _borderHeight);
    
    // bounds of highlight view 10% smaller than cell
    CGFloat highlightViewInset = viewSize.height * 0.1f;
    _highlightView.frame = CGRectInset(self.contentView.frame, highlightViewInset, highlightViewInset);
    _highlightView.layer.cornerRadius = CGRectGetHeight(_highlightView.bounds) / 2;
    
    //indicator
    CGFloat dotInset = viewSize.height * 0.45f;
    CGRect indicatorFrame = CGRectInset(self.contentView.frame, dotInset, dotInset);
    indicatorFrame.origin.y = CGRectGetMaxY(_highlightView.frame) - indicatorFrame.size.height * 1.5;
    _indicatorView.frame = indicatorFrame;
    _indicatorView.layer.cornerRadius = CGRectGetHeight(_indicatorView.bounds) / 2;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.contentView.backgroundColor = nil;
    _label.text = @"";
}

#pragma mark - C Helpers

NSString * MDCalendarDayStringFromDate(NSDate *date)
{
    return [NSString stringWithFormat:@"%d", (int)[date day]];
}

@end

