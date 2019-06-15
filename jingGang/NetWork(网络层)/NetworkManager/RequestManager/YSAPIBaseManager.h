//
//  YSAPIBaseManager.h
//  YSNetworkManagerDemo
//
//  Created by dengxf on 17/6/13.
//  Copyright © 2017年 dengxf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSAPIManagerProtocol.h"
#import "YSAPIResponse.h"
#import "YSAPICallbackProtocol.h"
#import "YSNetworkConstFile.h"
#import "YSRequestParamsManager.h"
#import "YSReformerDataProtocol.h"
#import "YSLoginManager.h"
#import "YSResponseDataReformer.h"

@class YSAPIBaseManager;
// 让manager能够获取所需要的参数
@protocol YSAPIManagerParamSource <NSObject>
@required

- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager;

@end

@interface YSAPIBaseManager : NSObject<YSAPIManagerProtocol>

// 遵守协议的子类，必须遵守YSAPIManagerProtocol协议
@property (weak,nonatomic) NSObject<YSAPIManagerProtocol> *childManager;

// 请求结果回调的代理，需要遵守YSAPICallbackProtocol协议
@property (weak, nonatomic) id<YSAPICallbackProtocol> delegate;

@property (weak, nonatomic) id<YSAPIManagerParamSource>paramSource;

// 自定义response用来统一保存数据和error
@property (strong,nonatomic) YSAPIResponse *response;

/**
 *  加载数据 */
- (void)requestData;

/**
 *  数据过滤的方法，必须要遵守YSReformerDataProtocol协议 */
- (id)fetchDataWithReformer:(id<YSReformerDataProtocol>)reformer;

/**
 *  是否需要缓存 */
- (NSNumber *)shouldCache;

/**
 *  取消请求 */
- (void)cancelAllRequest;

@end
