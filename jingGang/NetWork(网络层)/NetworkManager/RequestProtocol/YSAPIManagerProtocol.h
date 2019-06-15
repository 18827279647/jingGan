//
//  YSAPIManagerProtocol.h
//  YSNetworkManagerDemo
//
//  Created by dengxf on 17/6/13.
//  Copyright © 2017年 dengxf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YSAPIRequestType) {
    YSAPIRequestTypeGet = 0,
    YSAPIRequestTypePost,
    YSAPIRequestTypeUploadImage
};

@protocol YSAPIManagerProtocol <NSObject>

@required
// 请求方式
- (YSAPIRequestType)requestType;

// 请求参数
- (NSDictionary *)params;

// 请求的方法名
- (NSString *)requestMethod;

// 请求后完整的拼接参数
- (NSDictionary *)paramsForAPI;

/**
 *  自定义的请求头 */
- (NSDictionary *)headerDict;

@end
