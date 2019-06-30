//
//  RXGuideManager.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/29.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const RXGuidePageHomeKey = @"RXGuidePageHomeKey";
static NSString *const RXGuidePageMajorKey = @"RXGuidePageMajorKey";
static NSString *const RXThreeKey = @"RXThreeKey";
static NSString *const RXFiveKey = @"RXFiveKey";

typedef void(^FinishBlock)(void);

typedef NS_ENUM(NSInteger, RXGuidePageType) {
    RXGuidePageTypeHome = 0,
    RXGuidePageTypeMajor,
    RXGuidePageTypeThree,
    RXGuidePageTypeFive,
};

@interface RXGuideManager : NSObject

// 获取单例
+ (instancetype)shareManager;

/**
 显示方法
 
 @param type 指引页类型
 */
- (void)showGuidePageWithType:(RXGuidePageType)type;

/**
 显示方法
 
 @param type 指引页类型
 @param completion 完成时回调
 */
- (void)showGuidePageWithType:(RXGuidePageType)type completion:(FinishBlock)completion;

@end

NS_ASSUME_NONNULL_END
