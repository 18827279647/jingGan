//
//  YSLoginPopDataConfig.m
//  jingGang
//
//  Created by dengxf11 on 17/2/13.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSLoginPopDataConfig.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "WXApi.h"

@implementation YSLoginPopDataConfig

+ (NSInteger)configTirdthInstall {
    NSInteger i = 0;
    if ([WeiboSDK isWeiboAppInstalled]) {
        i++;
    }
    if ([WXApi isWXAppInstalled]) {
        i++;
    }
    if ([QQApiInterface isQQInstalled]) {
        i++;
    }
    return (i + 3);
}

+ (NSArray *)titles {
    if ([WeiboSDK isWeiboAppInstalled] && [WXApi isWXAppInstalled] && [QQApiInterface isQQInstalled]) {
        // 微信、微博、QQ都安装了
        return @[
                 @{
                     @"title":@"请先登录",
                     @"tag":[NSNumber numberWithInteger:-1]
                     },
                 @{
                     @"title":@"使用微信账号登录",
                     @"tag":@0
                     },
                 @{
                     @"title":@"使用新浪账号登录",
                     @"tag":@1
                     },
                 @{
                     @"title":@"使用QQ账号登录",
                     @"tag":@2
                     },
                 @{
                     @"title":@"使用手机账号登录",
                     @"tag":@3
                     },
                 @{
                     @"title":@"使用CN账号登录",
                     @"tag":@4
                     }
                 ];
    }
    if (![WXApi isWXAppInstalled] && [WeiboSDK isWeiboAppInstalled] && [QQApiInterface isQQInstalled]) {
        // 微信未安装 微博、QQ安装了
        return @[
                 @{
                     @"title":@"请先登录",
                     @"tag":[NSNumber numberWithInteger:-1]
                     },
                 @{
                     @"title":@"使用新浪账号登录",
                     @"tag":@1
                     },
                 @{
                     @"title":@"使用QQ账号登录",
                     @"tag":@2
                     },
                 @{
                     @"title":@"使用手机账号登录",
                     @"tag":@3
                     },
                 @{
                     @"title":@"使用CN账号登录",
                     @"tag":@4
                     }
                 ];
    }
    if ([WXApi isWXAppInstalled] && ![WeiboSDK isWeiboAppInstalled] && [QQApiInterface isQQInstalled]) {
        // 微博未安装 微信、QQ安装了
        return @[
                 @{
                     @"title":@"请先登录",
                     @"tag":[NSNumber numberWithInteger:-1]
                     },
                 @{
                     @"title":@"使用微信账号登录",
                     @"tag":@0
                     },

                 @{
                     @"title":@"使用QQ账号登录",
                     @"tag":@2
                     },
                 @{
                     @"title":@"使用手机账号登录",
                     @"tag":@3
                     },
                 @{
                     @"title":@"使用CN账号登录",
                     @"tag":@4
                     }
                 ];

    }
    
    if ([WXApi isWXAppInstalled] && [WeiboSDK isWeiboAppInstalled] && ![QQApiInterface isQQInstalled]) {
        // QQ未安装 微信、微博安装了
        return @[
                 @{
                     @"title":@"请先登录",
                     @"tag":[NSNumber numberWithInteger:-1]
                     },
                 @{
                     @"title":@"使用微信账号登录",
                     @"tag":@0
                     },
                 @{
                     @"title":@"使用新浪账号登录",
                     @"tag":@1
                     },
                 @{
                     @"title":@"使用手机账号登录",
                     @"tag":@3
                     },
                 @{
                     @"title":@"使用CN账号登录",
                     @"tag":@4
                     }
                 ];
    }
    
    if ([WeiboSDK isWeiboAppInstalled] && ![WXApi isWXAppInstalled] && ![QQApiInterface isQQInstalled]) {
        // 微博安装了 微信、QQ都未安装了
        return @[
                 @{
                     @"title":@"请先登录",
                     @"tag":[NSNumber numberWithInteger:-1]
                     },

                 @{
                     @"title":@"使用新浪账号登录",
                     @"tag":@1
                     },
                 @{
                     @"title":@"使用手机账号登录",
                     @"tag":@3
                     },
                 @{
                     @"title":@"使用CN账号登录",
                     @"tag":@4
                     }
                 ];
    }
    if (![WeiboSDK isWeiboAppInstalled] && ![WXApi isWXAppInstalled] && [QQApiInterface isQQInstalled]) {
        // QQ安装了 微信、微博都未安装了
        return @[
                 @{
                     @"title":@"请先登录",
                     @"tag":[NSNumber numberWithInteger:-1]
                     },
                 @{
                     @"title":@"使用QQ账号登录",
                     @"tag":@2
                     },
                 @{
                     @"title":@"使用手机账号登录",
                     @"tag":@3
                     },
                 @{
                     @"title":@"使用CN账号登录",
                     @"tag":@4
                     }
                 ];
    }
    if (![WeiboSDK isWeiboAppInstalled] && [WXApi isWXAppInstalled] && ![QQApiInterface isQQInstalled]) {
        // 微信安装了 微博、QQ都未安装了
        return @[
                 @{
                     @"title":@"请先登录",
                     @"tag":[NSNumber numberWithInteger:-1]
                     },
                 @{
                     @"title":@"使用微信账号登录",
                     @"tag":@0
                     },
                 @{
                     @"title":@"使用手机账号登录",
                     @"tag":@3
                     },
                 @{
                     @"title":@"使用CN账号登录",
                     @"tag":@4
                     }
                 ];
    }
    if (![WeiboSDK isWeiboAppInstalled] && ![WXApi isWXAppInstalled] && ![QQApiInterface isQQInstalled]) {
        // 微信、微博、QQ都未安装了
        return @[
                 @{
                     @"title":@"请先登录",
                     @"tag":[NSNumber numberWithInteger:-1]
                     },
                 @{
                     @"title":@"使用手机账号登录",
                     @"tag":@3
                     },
                 @{
                     @"title":@"使用CN账号登录",
                     @"tag":@4
                     }
                 ];
    }
    return @[];
}

//  1. wx 0  qq \ wb 1
//  2. qq 0  wx \ wb 1
//  3. wb 0  qq \ wx 1
//  4. wx qq 0  wb 1
//  5. wx wb 0  qq 1
//  6. qq wb 0  wx 1
//  7. qq wx wb 0
//  8. qq wx wb 1

@end
