//
//  YSRequestInstanceFactory.m
//  YSNetworkManagerDemo
//
//  Created by dengxf on 17/6/13.
//  Copyright © 2017年 dengxf. All rights reserved.
//

#import "YSRequestInstanceFactory.h"

@implementation YSRequestInstanceFactory

static YSRequestInstanceFactory *singleton = nil;
+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (id)requestInstance:(NSString *)instance{
    id requestInstance = [[NSClassFromString(instance) alloc] init];
    
    //如果没有遵守请求的协议就返回nil
    if (![requestInstance conformsToProtocol:@protocol(YSNetworkRequestProtocol)]) {
        return nil;
    }
    
    return requestInstance;
}

@end
