//
//  JGHeartRateTestProgressView.h
//  jingGang
//
//  Created by dengxf on 16/2/25.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YSTestProjectWithType) {
    /**
     *  心率 */
    YSTestProjectWithHeartRateType = 0,
    /**
     *  血氧 */
    YSTestProjectWithBloodOxyenType,
};

@interface JGHeartRateTestProgressView : UIView

- (instancetype)initWithFrame:(CGRect)frame testType:(YSTestProjectWithType)textType;

@property (assign, nonatomic) CGFloat heartRate;


- (void)setHeartRateData:(int)rateData;

- (void)setBloodOxyenData:(int)bloodData;

- (void)startAnimate;

- (void)stopAnimate;
@end
