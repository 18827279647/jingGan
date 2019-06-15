//
//  NSBundle+Extension.m
//  jingGang
//
//  Created by dengxf on 16/11/1.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "NSBundle+Extension.h"

@implementation NSBundle (Extension)

+ (NSString *)appName {
    NSBundle *bundle = [NSBundle mainBundle];
    
    NSString *appName = [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (!appName) {
        appName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
    }
    return appName;
}

/**
 *  优先获取CFBundleShortVersionString，如果获取为nil，则尝试获取kCFBundleVersionKey
 */
+ (NSString *)version {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ? :[[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey];
}


@end
