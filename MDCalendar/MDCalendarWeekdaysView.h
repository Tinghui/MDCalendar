//
//  MDCalendarWeekdaysView.h
//  MDCalendarDemo
//
//  Created by ZhangTinghui on 14-9-22.
//  Copyright (c) 2014年 ZhangTinghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDCalendarWeekdaysView : UIView

@property (nonatomic, strong) NSArray *dayLabels;

@property (nonatomic, assign) UIColor *textColor;
@property (nonatomic, assign) UIFont  *font;

+ (CGFloat)preferredHeightWithFont:(UIFont *)font;

@end
