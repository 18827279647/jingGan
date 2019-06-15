//
//  YSGoMissionController.h
//  jingGang
//
//  Created by HanZhongchou on 16/8/25.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "XK_ViewController.h"

typedef NS_ENUM(NSUInteger,YSEnterEarnInteralControllerType ) {
    // 拼手气
    YSEnterEarnInteralControllerWithRiskLuck = 0,
    // 健康管理首页
    YSEnterEarnInteralControllerWithHealthyManagerMainPage
};
@interface YSGoMissionController : XK_ViewController

@property (assign, nonatomic) YSEnterEarnInteralControllerType enterControllerType;

@end
