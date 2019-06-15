//
//  GlobeObject.m
//  ZCSuoPing
//
//  Created by caipeng on 14-11-14.
//  Copyright (c) 2014年 掌众传媒 www.chinamobiad.com. All rights reserved.
//

#import "GlobeObject.h"
#import "NSString+Extension.h"
#import "YSLoginManager.h"

@implementation GlobeObject

+ (NSString *)localDocumentPath
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
}

+ (BOOL)checkUserLoginedStateAndShouldHandleTokenError:(BOOL)handldTokenError {
    BOOL loginState = NO;
    if ([[YSLoginManager queryAccessToken] isEmpty] || [YSLoginManager queryAccessToken] == nil) {
        // 未登录
        if (handldTokenError) {
            [VApiManager handleNeedTokenError];
        }
        return NO;
    }else {
        loginState = YES;
    }
    return loginState;
}


@end
