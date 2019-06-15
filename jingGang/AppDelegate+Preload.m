//
//  AppDelegate+Preload.m
//  jingGang
//
//  Created by dengxf on 16/8/12.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "AppDelegate+Preload.h"
#import "YSLocationManager.h"
#import "YSLoginManager.h"
#import "YSSurroundAreaCityInfo.h"

@implementation AppDelegate (Preload)

- (void)openLocation {
    [YSLocationManager beginLocateSuccess:^{
        
    } fail:^{
        // 定位失败--
//        BLOCK_EXEC([YSLocationManager sharedInstance].fail);
    }];
}

- (void)checkUser {
    if (GetToken) {
        if ([YSLoginManager isCNAccount]) {
            [YSLoginManager checkCNAccountBindingTelSuccess:^(BOOL isBind,NSString *strMobileNum) {
                if (isBind) {
                    JGLog(@"CN账号已登录，已绑定手机!");
                }else {
                    [YSLoginManager loginout];
                }
            } fail:^(NSString *failMsg) {
                [YSLoginManager loginout];

            } error:^{
                [YSLoginManager loginout];
            } toController:nil account:nil password:nil controllerType:0 cnAccountBindResult:^(BOOL result) {
                
            }];
        }
    }
}

@end
