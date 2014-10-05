//
//  MDCalendarViewCell.h
//  MDCalendarDemo
//
//  Created by ZhangTinghui on 14-9-22.
//  Copyright (c) 2014年 ZhangTinghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDCalendarViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView  *highlightView;
@property (nonatomic, strong) UIView  *topBorderView;
@property (nonatomic, strong) UIView  *indicatorView;

@property (nonatomic, assign) UIFont  *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) UIColor *highlightColor;

@property (nonatomic, assign) CGFloat  borderHeight;
@property (nonatomic, assign) UIColor *borderColor;
@property (nonatomic, assign) UIColor *indicatorColor;

@property (nonatomic, assign) NSDate  *date;

@end
