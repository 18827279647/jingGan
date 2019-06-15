//
//  YSRequestInstanceFactory.h
//  YSNetworkManagerDemo
//
//  Created by dengxf on 17/6/13.
//  Copyright © 2017年 dengxf. All rights reserved.
//  工厂类的作用是返回那个网络库请求方法的实例

#import <Foundation/Foundation.h>
#import "YSNetworkRequestProtocol.h"

@interface YSRequestInstanceFactory : NSObject

+ (instancetype)shareInstance;

- (id)requestInstance:(NSString *)instance;

@end
