//
//  YSJPushHelper.m
//  jingGang
//
//  Created by dengxf on 17/5/16.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSJPushHelper.h"
#import "GlobeObject.h"
#import "YSJPushApsModel.h"
#import "NSObject+YYModel.h"
#import "JGDropdownMenu.h"
#import "YSLinkCYDoctorWebController.h"
#import "YSGestureNavigationController.h"
#import "YSJPushForegroundStateController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "YSLoginManager.h"
#import "MJExtension.h"
#import "ShoppingOrderDetailController.h"
#import "YSCloudMoneyDetailController.h"
#import "YSGetPushTagsManager.h"
#import "YSLinkElongHotelWebController.h"
#import "KJGoodsDetailViewController.h"
#import "YSLocationManager.h"
#import "WSJMerchantDetailViewController.h"
#import "ServiceDetailController.h"
#import "YSSurroundAreaCityInfo.h"
#import "WSJManagerAddressViewController.h"
#import "YSHealthAIOController.h"
#import "YSNearAdContentModel.h"
#import "MerchantPosterDetailVC.h"
#import "LJViewController.h"
#define kJPushForegroundShowDuration 2.4
#define kJPushForegroundWillDismissDuratin (kJPushForegroundShowDuration + 2.2)

@interface YSJPushHelper ()

@property (strong,nonatomic) JGDropdownMenu *menu;
/**
 *  在推送弹出来到消失之间是否点击过 */
@property (assign, nonatomic) BOOL isClickPushMsg;

@end

@implementation YSJPushHelper

#define kConfigCurrentStateWithInH5StateKey @"kConfigCurrentStateWithInH5StateKey"
#define kSetForegroundApnsStatesKey         @"kSetForegroundApnsStatesKey"




+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chunYuWebControllerDismiss) name:@"kPostDismissChunYuDoctorWebKey" object:nil];
}

+ (void)setForegroundApnsStates:(YSHandleForegroundApnsProcess)apnsStates {
    NSNumber *states;
    switch (apnsStates) {
        case YSForegroundApnsProcessIdle:
            states = @100;
            break;
        case YSForegroundApnsProcessBegin:
            states = @101;
            break;
        case YSForegroundApnsProcessBeing:
            states = @102;
            break;
        case YSForegroundApnsProcessEnd:
            states = @103;
            break;
        default:
            break;
    }
    [self save:states key:kSetForegroundApnsStatesKey];
}

+ (YSHandleForegroundApnsProcess)acquireForefroundApnsStates {
    return [[self achieve:kSetForegroundApnsStatesKey] integerValue];
}

+ (void)chunYuWebControllerDismiss {
    [[YSJPushHelper sharedInstance].menu dismiss];
}

+ (void)registerJPushWithOptions:(NSDictionary *)options
{
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:options appKey:JPushAppKey
                          channel:@"App Store"
                 apsForProduction:FALSE
            advertisingIdentifier:nil];
}

+ (void)jpushSetAlias:(NSString *)alias {
//    JGLog(@"******JPush Set alias:%@",alias);
    
   [[YSGetPushTagsManager sharedInstance] getPushTagsCallBack:^(NSSet *set) {
       [JPUSHService setTags:set alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
           JGLog(@"******JPush Set alias result**%d---%@---%@",iResCode,iTags,iAlias);
       }];
    }];
}

+ (void)jpushRemoveAlias {
//    JGLog(@"***JPush Remove alias");
    [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//        JGLog(@"%d-----%@----%@",iResCode,iTags,iAlias);
    }];
}

+ (void)unregisterForRemoteNotifications {
//    JGLog(@"*****UnregisterForRemoteNotifications");
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

+ (void)registerForRemoteNotifications {
//    JGLog(@"*****registerForRemoteNotifications");
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

+ (void)configWithInChunYuH5:(BOOL)withInH5 {
    if (withInH5) {
        [self save:@1 key:kConfigCurrentStateWithInH5StateKey];
    }else {
        [self save:@0 key:kConfigCurrentStateWithInH5StateKey];
    }
}


+ (BOOL)queryCurrentStateWithInChunYuH5 {
    return [[self achieve:kConfigCurrentStateWithInH5StateKey] boolValue];
}

+ (NSString *)jpushContentWithJPushModel:(YSJPushApsModel *)pushModel {
    if ([pushModel.aps.alert isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@",pushModel.aps.alert];
    }else if ([pushModel.aps.alert isKindOfClass:[NSDictionary class]]) {
        NSDictionary *alertDict = [NSDictionary dictionaryWithDictionary:pushModel.aps.alert];
        return [NSString stringWithFormat:@"%@",alertDict[@"body"]];
    }else {
        return @"您咨询的问题,专家已为您解答,请立即查看!";
    }
}

#pragma mark 配置推送类型 ****
+ (void)configJpushMessageType:(YSJPushApsModel *)jpushModel {
    if ([jpushModel.messageType isEqualToString:@"PROBLEM_REPLY"]) {
        // 春雨医生消息回复
        [YSJPushHelper sharedInstance].msgType = YSChunYuProblemReplyType;
    }else if ([jpushModel.messageType isEqualToString:@"PROBLEM_CLOSE"]) {
        // 春雨医生问题关闭
        [YSJPushHelper sharedInstance].msgType = YSChunYuProblemCloseType;
    }else if ([jpushModel.messageType isEqualToString:@"serverOrderDetails"]) {
        // 周边服务订单详情
        [YSJPushHelper sharedInstance].msgType = YSServiceOrderDetailType;
    }else if ([jpushModel.messageType isEqualToString:@"cloudmoney"]) {
        
        [YSJPushHelper sharedInstance].msgType = YSCloudMoneyDetailType;
    }
}

+ (void)dealJPushWithUserInfo:(NSDictionary *)userInfo {
    // 当前用户不在H5， 需要做推送处理
    YSJPushApsModel *jpushModel = [YSJPushApsModel modelWithDictionary:userInfo];
    // 配置推送类型
    [self configJpushMessageType:jpushModel];
    
    UIApplicationState applicationState = [UIApplication sharedApplication].applicationState;
    switch (applicationState) {
        case UIApplicationStateActive:
        {
//            JGLog(@"****推送环境在前台");
            [YSJPushHelper sharedInstance].isClickPushMsg = NO;
            [self jpushCurrenStateWithForegroundModeWithApsModel:jpushModel];
        }
            break;
        default:
        {
//            JGLog(@"****推送环境在后台");
            [self jpushCurrentStateWithBackgroundModeWithApsModel:jpushModel];
        }
            break;
    }
}

/**
 *  处理后台推送 */
+ (void)jpushCurrentStateWithBackgroundModeWithApsModel:(YSJPushApsModel *)apsModel
{
    // 当前用户在H5之内， 推送不处理(需要把站内消息)
    if ([self queryCurrentStateWithInChunYuH5]) {
//        JGLog(@"******后台环境中推送，在H5内，不弹框，默认消除消息");
        return;
    }
    [self pushControllerWithJPApsModel:apsModel];
    if (apsModel.mType.integerValue == 4 && [[apsModel.linkUrl substringToIndex:3] isEqualToString:@"zbs"] && apsModel.pageType.integerValue == 7) {
        //不是争霸赛的情况下才调用已读消息接口,争霸赛设置地址成功后再设置已读
        return;
    }
    NSString *questionId = [NSString stringWithFormat:@"%@",apsModel.messageId];
    [self dealClickJPushWithQuestionId:[NSNumber numberWithInteger:[questionId integerValue]]];
}

+ (void)pushControllerWithJPApsModel:(YSJPushApsModel *)apsModel {
    JGDropdownMenu *menu = [JGDropdownMenu menu];
    YSGestureNavigationController *navController = [[YSGestureNavigationController alloc] initWithRootViewController:[self jpushControllerWithJPApsModel:apsModel]];
    menu.contentController = navController;
    [menu showWithFrameWithDuration:0.25];
    [YSJPushHelper sharedInstance].menu = menu;
}

#pragma mark  返回推送消息目的视图控制器
+ (UIViewController *)jpushControllerWithJPApsModel:(YSJPushApsModel *)apsModel {
    UIViewController *jpushController = nil;
    
    if (apsModel.mType.integerValue == 4) {
        //广告位跳转
        jpushController = [self getAdContentPushNoticeViewControllerWithPushModel:apsModel];
    }else if(apsModel.mType.integerValue == 3 || apsModel.mType.integerValue == 1) {
        // 站内消息。文本、富文本
        MerchantPosterDetailVC *noticeDetailController = [[MerchantPosterDetailVC alloc] init];
        noticeDetailController.posterID = @(apsModel.messageId.integerValue);
        jpushController = noticeDetailController;
    }else if ([apsModel.messageType isEqualToString:@"couponGainCenter"]){
        NSLog(@"apsModel.content:%@",apsModel.content);
         LJViewController *LJVC = [[LJViewController alloc]init];
          LJVC.hidesBottomBarWhenPushed = YES;
         jpushController = LJVC;
        
    } else{
        switch ([YSJPushHelper sharedInstance].msgType) {
            case YSServiceOrderDetailType:
            {
                // 订单详情
                ShoppingOrderDetailController *serviceOrderVC = [[ShoppingOrderDetailController alloc] init];
                serviceOrderVC.orderId = [apsModel.orderId longLongValue];
                serviceOrderVC.showRefundRefuseAlert = YES;
                serviceOrderVC.refuseReasonString = [NSString stringWithFormat:@"%@",apsModel.aps.alert];
                jpushController = serviceOrderVC;
            }
                break;
            case YSCloudMoneyDetailType:
            {
                // 健康豆详情
                YSCloudMoneyDetailController *cloudMoneyDetailController = [[YSCloudMoneyDetailController alloc] init];
                jpushController = cloudMoneyDetailController;
            }
                break;
            default:
            {
                // 春雨医生
                YSLinkCYDoctorWebController *viewCtrl = [[YSLinkCYDoctorWebController alloc] initWithWebUrl:apsModel.url];
                viewCtrl.controllerPushType = YSControllerPushFromCustomViewType;
                jpushController = viewCtrl;
            }
                break;
        }
    }
    jpushController.view.width = ScreenWidth;
    jpushController.view.height = ScreenHeight;
    return jpushController;
}

/**
 *  处理前台推送 */
+ (void)jpushCurrenStateWithForegroundModeWithApsModel:(YSJPushApsModel *)apsModel
{
    if ([YSJPushHelper sharedInstance].msgType == YSChunYuProblemReplyType || [YSJPushHelper sharedInstance].msgType == YSChunYuProblemCloseType) {
        // 春雨医生类型
        if ([self queryCurrentStateWithInChunYuH5]) {
            NSString *questionId = [NSString stringWithFormat:@"%@",apsModel.messageId];
            [self dealClickJPushWithQuestionId:[NSNumber numberWithInteger:[questionId integerValue]]];
//            JGLog(@"******后台环境中推送，在H5内，不弹框，默认消除消息");
            return;
        }
    }
    if (!([self acquireForefroundApnsStates] == YSForegroundApnsProcessIdle)) {
        // 非闲置状态 对其他的推送不做处理
//        JGLog(@"******有推送行为正在进行");
        return;
    }
    // 将推送状态设置为开始
    [self setForegroundApnsStates:YSForegroundApnsProcessBegin];
    JGDropdownMenu *menu = [JGDropdownMenu menu];
    YSJPushForegroundStateController *controller = [YSJPushForegroundStateController new];
    controller.jpushContent = [self jpushContentWithJPushModel:apsModel];
    controller.jpushUrl = apsModel.url;
    controller.jpushModel = apsModel;
    controller.pushClickCallback = ^(){
        // 点击推送信息
        // 本次推送服务结束
        [self setForegroundApnsStates:YSForegroundApnsProcessEnd];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setForegroundApnsStates:YSForegroundApnsProcessIdle];
        });
        [YSJPushHelper sharedInstance].isClickPushMsg = YES;
        
        if (apsModel.mType.integerValue == 4 && [[apsModel.linkUrl substringToIndex:3] isEqualToString:@"zbs"] && apsModel.pageType.integerValue == 7) {
            //不是争霸赛的情况下才调用已读消息接口,争霸赛设置地址成功后再设置已读
            return;
        }
        NSString *questionId = [NSString stringWithFormat:@"%@",apsModel.messageId];
        [self dealClickJPushWithQuestionId:[NSNumber numberWithInteger:[questionId integerValue]]];
    };
    YSGestureNavigationController *navController = [[YSGestureNavigationController alloc] initWithRootViewController:controller];
    navController.view.width = ScreenWidth;
    navController.view.height = ScreenHeight;
    navController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    menu.contentController = navController;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    });
    [menu showWithFrameFromTopWithDuration:kJPushForegroundShowDuration];
    [YSJPushHelper sharedInstance].menu = menu;
    // 将推送状态设置成正在进行
    [self setForegroundApnsStates:YSForegroundApnsProcessBeing];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kJPushForegroundWillDismissDuratin * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[YSJPushHelper sharedInstance].menu dismissWithDirection:ShowDropViewDirectionFromTop duration:0 animated:YES dismiss:NO end:^{
            if ([YSJPushHelper sharedInstance].isClickPushMsg) {
                // 点击过了
//                JGLog(@"****clicked don't dismiss");
            }else {
                // 推送消息不做处理 dismiss
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kChunYuDoctorWillDismissNotification" object:nil];
                [[YSJPushHelper sharedInstance].menu dismissWithDirection:ShowDropViewDirectionFromTop duration:1.36 animated:YES dismiss:YES end:NULL];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 推送消息不处理 推送结束
                    [self setForegroundApnsStates:YSForegroundApnsProcessEnd];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.38 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        // 推送结束 0.38秒后置空闲
                        [self setForegroundApnsStates:YSForegroundApnsProcessIdle];
                    });
                });
            }
        }];
    });
}

+ (UIViewController *)getAdContentPushNoticeViewControllerWithPushModel:(YSJPushApsModel *)pushModel{
    UIViewController *viewController = nil;
    switch ([pushModel.pageType integerValue]) {
        case 1:
        {
            // 链接
            NSString *appendUrlString;
            if([pushModel.linkUrl rangeOfString:@"?"].location !=NSNotFound)//_roaldSearchText
            {
                appendUrlString = [NSString stringWithFormat:@"%@&cityName=%@",pushModel.linkUrl,[YSLocationManager currentCityName]];
            }else{
                appendUrlString = [NSString stringWithFormat:@"%@?cityName=%@",pushModel.linkUrl,[YSLocationManager currentCityName]];
            }
            appendUrlString = [appendUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //一键客 看这里
            YSLinkElongHotelWebController *elongHotelWebController = [[YSLinkElongHotelWebController alloc] initWithWebUrl:appendUrlString];
            elongHotelWebController.hidesBottomBarWhenPushed = YES;
            elongHotelWebController.navTitle = pushModel.title;
            viewController = elongHotelWebController;

        }
            break;
        case 2:
        {
            // 商品详情
            KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
            goodsDetailVC.goodsID = [NSNumber numberWithInteger:[pushModel.linkUrl integerValue]];
            goodsDetailVC.hidesBottomBarWhenPushed = YES;
            viewController = goodsDetailVC;
        }
            break;
        case 5:
        {
            // 商户详情
            WSJMerchantDetailViewController *goodStoreVC = [[WSJMerchantDetailViewController alloc] init];
            goodStoreVC.api_classId = [NSNumber numberWithInteger:[pushModel.linkUrl integerValue]];
            goodStoreVC.hidesBottomBarWhenPushed = YES;
            viewController = goodStoreVC;
        }
            break;
        case 6:
        {
            //服务详情
            ServiceDetailController *serviceDetailVC = [[ServiceDetailController alloc] init];
            serviceDetailVC.serviceID = [NSNumber numberWithInteger:[pushModel.linkUrl integerValue]];
            serviceDetailVC.hidesBottomBarWhenPushed = YES;
            if ([YSSurroundAreaCityInfo isElseCity]) {
                serviceDetailVC.api_areaId = [YSSurroundAreaCityInfo achieveElseSelectedAreaInfo].areaId;
            }else {
                YSLocationManager *locationManager = [YSLocationManager sharedInstance];
                serviceDetailVC.api_areaId = locationManager.cityID;
            }
            viewController = serviceDetailVC;
        }
            break;
        case 7:
        {
            // 原生类别区分 link
            if ([pushModel.linkUrl isEqualToString:YSAdvertOriginalTypeAIO]) {
                YSHealthAIOController *healthAIOController = [[YSHealthAIOController alloc] init];
                healthAIOController.hidesBottomBarWhenPushed = YES;
                viewController = healthAIOController;
            }else if ([[pushModel.linkUrl substringToIndex:3] isEqualToString:@"zbs"]){
                //争霸赛跳转
                WSJManagerAddressViewController *managerAddressVC = [[WSJManagerAddressViewController alloc]init];
                managerAddressVC.type = JPushCome;
                managerAddressVC.linkUrl = pushModel.linkUrl;
                viewController = managerAddressVC;
            }
        }
            break;
        default:
            break;
    }

    return viewController;
}


#pragma mark 处理推送操作后站内消息设置为已读---
+ (void)dealClickJPushWithQuestionId:(NSNumber *)questionId {
    VApiManager *manager = [[VApiManager alloc] init];
    UserMessageDetailRequest *request = [[UserMessageDetailRequest alloc]init:[YSLoginManager queryAccessToken]];
    request.api_id = questionId;
    [manager userMessageDetail:request success:^(AFHTTPRequestOperation *operation, UserMessageDetailResponse *response) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
