//
//  CWStarRateView.h
//  StarRateDemo
//
//  Created by WANGCHAO on 14/11/4.
//  Copyright (c) 2014年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFStarRateView;
@protocol XFStarRateViewDelegate <NSObject>
@optional
- (void)starRateView:(XFStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent;
@end

@interface XFStarRateView : UIView

@property (nonatomic, assign) CGFloat scorePercent;//得分值，范围为0--1，默认为1
@property (nonatomic, assign) BOOL hasAnimation;//是否允许动画，默认为NO
@property (nonatomic, assign) BOOL allowIncompleteStar;//评分时是否允许不是整星，默认为NO

@property (nonatomic, weak) id<XFStarRateViewDelegate>delegate;
@property (copy , nonatomic) NSString *foregroundImg;
@property (copy , nonatomic) NSString *backgroundImg;


- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars;


- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars foregroundImg:(NSString *)foregroundImg backgroundImg:(NSString *)backgroundImg;

@end
