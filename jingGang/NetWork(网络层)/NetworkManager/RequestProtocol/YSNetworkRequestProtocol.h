//
//  YSNetworkRequestProtocol.h
//  YSNetworkManagerDemo
//
//  Created by dengxf on 17/6/13.
//  Copyright © 2017年 dengxf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YSNetworkRequestProtocol <NSObject>

@required

- (NSURLSessionDataTask *)requestByGetWithParams:(NSDictionary *)params success:(void(^)(id responseObject))success fail:(void(^)(NSError *error))failure;

- (NSURLSessionDataTask *)requestByPostWithParams:(NSDictionary *)params success:(void(^)(id responseObject))success fail:(void(^)(NSError *error))failure;

/*
 * 这个方法中字典必须包含url和图片内容,统一设置key为EWRequestURLKey和EWUploadImageKey;
 */
- (NSURLSessionDataTask *)uploadImageByPostWithParams:(NSDictionary *)params success:(void(^)(id responseObject))success fail:(void(^)(NSError *error))failure;

@end
