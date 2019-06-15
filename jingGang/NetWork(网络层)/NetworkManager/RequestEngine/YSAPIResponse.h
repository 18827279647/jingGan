//
//  YSAPIResponse.h
//  YSNetworkManagerDemo
//
//  Created by dengxf on 17/6/13.
//  Copyright © 2017年 dengxf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSAPIResponse : NSObject
//请求数据
@property (strong,nonatomic) id responseObject;

//请求的原始数据
@property (strong,nonatomic) NSData *responseData;

//请求错误
@property (strong,nonatomic) NSError *error;

/**
 *  初始化方法，如果用AFNetworking使用这个方法 */
- (instancetype)initWithResponseObject:(id)responseObject error:(NSError *)error;

/**
 *  初始化方法，如果是用原生使用这个方法 */
- (instancetype)initWithData:(NSData *)data error:(NSError *)error;

@end
