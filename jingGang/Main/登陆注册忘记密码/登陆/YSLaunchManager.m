//
//  YSLunchManager.m
//  jingGang
//
//  Created by dengxf on 16/9/21.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSLaunchManager.h"

NSString * const kuserFirstLaunchKey = @"kuserFirstLaunchKey";
NSString * const kuserSupplyInfoKey = @"kuserSupplyInfoKey";

@implementation YSLaunchManager

+ (void)setFirstLaunchMode:(BOOL)launch {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:launch forKey:kuserFirstLaunchKey];
    [defaults synchronize];
}

+ (BOOL)isFirstLauchMode {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kuserFirstLaunchKey];
}

+ (void)setNeedSupplyInfo:(BOOL)supply {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:supply forKey:kuserSupplyInfoKey];
    [defaults synchronize];
}

+ (BOOL)isSupplyInfo {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kuserSupplyInfoKey];

}

@end
