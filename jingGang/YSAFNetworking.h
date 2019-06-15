//
//  YSAFNetworking.h
//  jingGang
//
//  Created by whlx on 2019/5/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

/*
 *  block回调传参
 */
typedef void(^successBlock)(NSURLSessionDataTask *operation, id responseObject);
typedef void(^failureBlock)(NSURLSessionDataTask *operation, NSError *error);

NS_ASSUME_NONNULL_BEGIN

@interface YSAFNetworking : NSObject

/*
 *。GET请求
 */
+ (void)GetUrlString:(NSString *)UrlString parametersDictionary:(NSDictionary *)dict successBlock:(successBlock)successBlock failureBlock:(failureBlock)failureBlock;

/*
 *。POST请求
 */
+ (void)POSTUrlString:(NSString *)UrlString parametersDictionary:(NSDictionary *)dict successBlock:(successBlock)successBlock failureBlock:(failureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
