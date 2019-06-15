//
//  YSRequestParamsManager.h
//  YSNetworkManagerDemo
//
//  Created by dengxf on 17/6/14.
//  Copyright © 2017年 dengxf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSRequestParamsManager : NSObject

+ (NSDictionary *)paramsDictWithUrl:(NSString *)url paramsDict:(NSDictionary *)dict cacheTime:(NSNumber *)cacheTime headerDict:(NSDictionary *)headDict;

@end
