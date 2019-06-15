//
//  YSAPIBaseManager.m
//  YSNetworkManagerDemo
//
//  Created by dengxf on 17/6/13.
//  Copyright © 2017年 dengxf. All rights reserved.
//

#import "YSAPIBaseManager.h"
#import "YSAPIRequest.h"

@interface YSAPIBaseManager ()

@property (strong,nonatomic) YSAPIRequest *apiRequest;

@end

@implementation YSAPIBaseManager

- (NSString *)requestMethod {
    return nil;
}

- (YSAPIRequestType)requestType {
    return 0;
}

- (NSDictionary *)paramsForAPI {
    return nil;
}

- (NSDictionary *)params {
    return nil;
}

- (NSDictionary *)headerDict {
    return nil;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _paramSource = nil;
        if ([self conformsToProtocol:@protocol(YSAPIManagerProtocol)]) {
            self.childManager = (NSObject<YSAPIManagerProtocol> *)self;
        }
    }
    return self;
}

#pragma mark 加载数据
- (void)requestData {
    NSDictionary *paramsDict = [self loadDynamicParamsDict];
    
    __weak typeof(self) weakSelf = self;
    switch (self.childManager.requestType) {
        case YSAPIRequestTypeGet:
        {
            [self.apiRequest sendRequestByGetWithParams:paramsDict
                                                success:^(YSAPIResponse *response) {
                                                    [weakSelf requestSuccess:response];
                                                } fail:^(YSAPIResponse *response) {
                                                    [weakSelf requestFailed:response];
                                                }];
        }
            break;
        case YSAPIRequestTypePost:
        {
            [self.apiRequest sendRequestByPostWithParams:paramsDict success:^(YSAPIResponse *response) {
                [weakSelf requestSuccess:response];
            } fail:^(YSAPIResponse *response) {
                [weakSelf requestFailed:response];
            }];
        }
            break;
        case YSAPIRequestTypeUploadImage:
        {
            [self.apiRequest sendRequestByPostImageWithParams:paramsDict success:^(YSAPIResponse *response) {
                [weakSelf requestSuccess:response];
            } fail:^(YSAPIResponse *response) {
                [weakSelf requestFailed:response];
            }];
        }
            break;
        default:
            break;
    }
}

- (NSDictionary *)loadDynamicParamsDict {
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSDictionary *paramsDict = [NSDictionary dictionary];
    if (params) {
        paramsDict = [YSRequestParamsManager paramsDictWithUrl:[self requestMethod] paramsDict:params cacheTime:[self shouldCache] headerDict:[self headerDict]];
    }else {
        paramsDict = self.childManager.paramsForAPI;
    }
    return paramsDict;
}

//回调成功的response,里面保存了请求成功的数据
- (void)requestSuccess:(YSAPIResponse *)response{
    self.response = response;
    if ([self.delegate respondsToSelector:@selector(managerCallBackDidSuccess:)]) {
        [self.delegate managerCallBackDidSuccess:self];
    }
}
//回调失败的response,里面保存了请求失败的错误信息
- (void)requestFailed:(YSAPIResponse *)response{
    self.response = response;
    if ([self.delegate respondsToSelector:@selector(managerCallBackDidFailed:)]) {
        [self.delegate managerCallBackDidFailed:self];
    }
}

#pragma mark 数据过滤的方法，必须要遵守YSReformerDataProtocol协议
- (id)fetchDataWithReformer:(id<YSReformerDataProtocol>)reformer {
    id responseData = nil;
    if ([reformer respondsToSelector:@selector(fetchDataWithReformer:)]) {
        responseData = [reformer reformDataWithAPIManager:self];
    }else {
        responseData = [self.response.responseObject mutableCopy];
    }
    return responseData;
}

#pragma mark 是否需要缓存
// 默认关闭缓存
- (NSNumber *)shouldCache {
    return @0;
}

#pragma mark 取消请求
- (void)cancelAllRequest {
    [self.apiRequest cancelRequest];
}

- (YSAPIRequest *)apiRequest{
    if (!_apiRequest) {
        _apiRequest = [YSAPIRequest requestManager];
    }
    return _apiRequest;
}

- (void)dealloc {
    
}

@end
