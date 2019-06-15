//
//  NSObject+UserDefaults.m
//  jingGang
//
//  Created by dengxf on 16/12/15.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "NSObject+UserDefaults.h"

@implementation NSObject (UserDefaults)

+ (void)save:(id)obj key:(NSString *)key {
    [[NSObject new] save:obj key:key];
}

- (void)save:(id)obj key:(NSString *)key {
    if (!obj) {
        return;
    }
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *objString = [NSString stringWithFormat:@"%@",obj];
        if ([objString isEmpty]) {
            return;
        }
        if (!objString.length) {
            return;
        }
    }
    if ([key isEmpty]) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:key];
    [defaults synchronize];
}


+ (id)achieve:(NSString *)key {
    return [[NSObject new]  achieve:key];
}

- (id)achieve:(NSString *)key {
    if ([key isEmpty]) {
        return nil;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

+ (void)remove:(NSString *)key {
    return [[NSObject new] remove:key];
}

- (void)remove:(NSString *)key {
    if ([key isEmpty]) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

@end
