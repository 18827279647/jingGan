//
//  AboutYunEs.h
//  jingGang
//
//  Created by wangying on 15/6/14.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YSHtmlControllerType) {
    /**
     *  关于e生康缘 */
    YSHtmlControllerWithAboutUs = 0,
    /**
     *  血压 */
    YSHtmlControllerWithBloodPressure,
    /**
     *  心率 */
    YSHtmlControllerWithHeartRate,
    /**
     *  肺活量 */
    YSHtmlControllerWithLung,
    /**
     *  血氧 */
    YSHtmlControllerWithBloodOxyen,
    /**
     *  健康圈规则 */
    YSHtmlControllerWithFriendCircleRule,
    /**
     *  提现规则 */
    YSHtmlControllerWithCashRule,
    /**
     *  精准健康检测 */
    YSHtmlControllerWithAIO,
    /**
     * 用户服务协议  */
    YSHtmlControllerWithUserServicetreaty
};

@interface AboutYunEs : UIViewController

- (instancetype)initWithType:(YSHtmlControllerType)controllerType;
@property(nonatomic,strong)NSString *strUrl;
@property(nonatomic,assign)NSInteger ind;
@property(nonatomic,strong) NSDictionary *dic;
@property (copy , nonatomic) NSString *navTitle;

@end
