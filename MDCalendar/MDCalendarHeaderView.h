//
//  MDCalendarHeaderView.h
//  MDCalendarDemo
//
//  Created by ZhangTinghui on 14-9-22.
//  Copyright (c) 2014年 ZhangTinghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDCalendarHeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) NSDate *firstDayOfMonth;

@property (nonatomic, assign) UIFont  *font;
@property (nonatomic, assign) UIColor *textColor;

@property (nonatomic, assign) UIEdgeInsets labelInset;

+ (CGFloat)preferredHeightWithMonthLabelFont:(UIFont *)monthFont;

@end
