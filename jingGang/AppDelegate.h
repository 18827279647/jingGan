//
//  AppDelegate.h
//  jingGang
//
//  Created by yi jiehuang on 15/5/7.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "weatherManager.h"
#import "advertManager.h"
#import "LeftSlideViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "WXApi.h"
#import "KJOrderStatusQuery.h"
#import "DefineEnum.h"
#import <BaiduMapAPI/BMapKit.h>
#import "YSJPushHelper.h"

#define versionOldNum @"version"
#define ISFISTRINSTALL @"ISFISTRINSTALL"

typedef NS_ENUM(NSUInteger, YSLoginCloseType) {
    YSLoginLeaderCloseType,
    YSLoginCommonCloseType
};

typedef void(^WXCodeReqBlock)(NSString *code);
@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,weatherManagerDelegate,advertManagerDelegate,WXApiDelegate,BMKGeneralDelegate>
{
    weatherManager       *_weatherManager;

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) NSInteger timeforCheck;
//是从个人中心跳转
@property (nonatomic,assign)BOOL isPersonCenterTtravel;

//支付跳转nav,
@property (nonatomic, strong)UINavigationController *payCommepletedTransitionNav;

//订单id
@property (nonatomic, strong)NSNumber *orderID;

@property (nonatomic, assign)JingGangPay jingGangPay;

//查询订单
@property (nonatomic, strong)KJOrderStatusQuery *orderStatusQuery;

//支付验证请求
@property (nonatomic, strong)ShopTradePaymetRequest *payResultRequest;

@property (copy , nonatomic)  WXCodeReqBlock wxCodeBlock;

@property (assign, nonatomic) BOOL getWXCode;

- (void)gogogoWithTag:(int)tag shouldNotityMainController:(BOOL)isNotity;
- (void)gogogoWithTag:(int)tag;
//判断是否第一次安装
- (BOOL)isFirstInstall;

- (UIViewController *)getCurrentVC;


- (void)login;
/**
 *  跳转登陆界面
 */
- (void)beGinLoginWithType:(YSLoginCloseType)loginType toLogin:(BOOL)toLogin;
- (BOOL)connectedToNetwork;
@end

