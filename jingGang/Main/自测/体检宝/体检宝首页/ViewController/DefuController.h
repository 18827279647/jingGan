//
//  DefuController.h
//  jingGang
//
//  Created by wangying on 15/6/27.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YSInputValueType) {
    /**
     *  血压 */
    YSInputValueWithBloodPressureType = 0,
    /**
     *  血氧 */
    YSInputValueWithBloodOxygenType,
    /**
     *  肺活量 */
    YSInputValyeWithLungcapacityType,
    /**
     *  心率值 */
    YSInputValyeWithHeartRateType
};

@interface DefuController : UIViewController
@end
