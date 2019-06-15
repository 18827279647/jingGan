//
//  YSAPIRequest.m
//  YSNetworkManagerDemo
//
//  Created by dengxf on 17/6/13.
//  Copyright © 2017年 dengxf. All rights reserved.
//

#import "YSAPIRequest.h"
#import "YSAPIResponse.h"
#import "YSRequestInstanceFactory.h"
#import "YSNetworkConstFile.h"

@interface YSAPIRequest ()

// 保存dataTask的数组，用于取消任务
@property (strong,nonatomic) NSMutableArray *dataTaskArray;

@end

@implementation YSAPIRequest

static YSAPIRequest *singleton = nil;
+ (instancetype)requestManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (NSURLSessionDataTask *)sendRequestByGetWithParams:(NSDictionary *)params success:(void (^)(YSAPIResponse *))success fail:(void (^)(YSAPIResponse *))failure{
    
    NSURLSessionDataTask *dataTask = nil;

    //通过工厂类获得请求的实例,实例必须遵循这个请求的协议
    //这里采用硬编码的方式,决定到底是用什么库来进行网络请求,目的在于方便切换网络库
    //KEWRequestByAFN表示采用AFN这个网络库请求数据
    
    id<YSNetworkRequestProtocol> requestInstance = [[YSRequestInstanceFactory shareInstance] requestInstance:kYSRequestByAFN];
    
    //请求数据
    dataTask = [requestInstance requestByGetWithParams:params success:^(id responseObject) {
        
        //生成统一管理网络数据的response
        //存入回调的数据
        YSAPIResponse *response = [[YSAPIResponse alloc] initWithResponseObject:responseObject error:nil];
        //回调这个response
        success ? success(response) : nil;
    } fail:^(NSError *error) {
        //存入错误信息
        YSAPIResponse *errorResponse = [[YSAPIResponse alloc] initWithResponseObject:nil error:error];
        //回调这个response
        failure ? failure(errorResponse) : nil;
        NSLog(@"请求失败-->%@",error);
    }];
    
    //加入dataTask
    [self.dataTaskArray addObject:dataTask];
    
    return dataTask;
}

- (NSURLSessionDataTask *)sendRequestByPostWithParams:(NSDictionary *)params success:(void (^)(YSAPIResponse*))success fail:(void (^)(YSAPIResponse *))failure{
    NSURLSessionDataTask *dataTask = nil;
    //通过工厂类获得请求的实例,实例必须遵循这个请求的协议
    id<YSNetworkRequestProtocol> requestInstance = [[YSRequestInstanceFactory shareInstance] requestInstance:kYSRequestByAFN];
    //请求数据
    dataTask = [requestInstance requestByPostWithParams:params success:^(id responseObject) {
        YSAPIResponse *response = [[YSAPIResponse alloc] initWithResponseObject:responseObject error:nil];
        success ? success(response) : nil;
    } fail:^(NSError *error) {
        YSAPIResponse *errorResponse = [[YSAPIResponse alloc] initWithResponseObject:nil error:error];
        failure ? failure(errorResponse) : nil;
        NSLog(@"请求失败-->%@",error);
    }];
    
    [self.dataTaskArray addObject:dataTask];
    
    return dataTask;
}

- (NSURLSessionDataTask *)sendRequestByPostImageWithParams:(NSDictionary *)params success:(void (^)(YSAPIResponse*))success fail:(void (^)(YSAPIResponse *))failure{
    NSURLSessionDataTask *dataTask = nil;
    //通过工厂类获得请求的实例,实例必须遵循这个请求的协议
    id<YSNetworkRequestProtocol> requestInstance = [[YSRequestInstanceFactory shareInstance] requestInstance:kYSRequestByAFN];
    //请求数据
    dataTask = [requestInstance uploadImageByPostWithParams:params success:^(id responseObject) {
        YSAPIResponse *response = [[YSAPIResponse alloc] initWithResponseObject:responseObject error:nil];
        success ? success(response) : nil;
    } fail:^(NSError *error) {
        YSAPIResponse *errorResponse = [[YSAPIResponse alloc] initWithResponseObject:nil error:error];
        failure ? failure(errorResponse) : nil;
        NSLog(@"请求失败-->%@",error);
    }];
    [self.dataTaskArray addObject:dataTask];
    return dataTask;
}

- (void)cancelRequest{
    if (self.dataTaskArray.count == 0) return;
    for (NSURLSessionDataTask* dataTask in self.dataTaskArray) {
        [dataTask cancel];
    }
    [self.dataTaskArray removeAllObjects];
}

- (NSMutableArray *)dataTaskArray{
    if (!_dataTaskArray) {
        _dataTaskArray = [NSMutableArray array];
    }
    return _dataTaskArray;
}
@end
