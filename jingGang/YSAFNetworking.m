//
//  YSAFNetworking.m
//  jingGang
//
//  Created by whlx on 2019/5/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "YSAFNetworking.h"

#import "GlobeObject.h"

@implementation YSAFNetworking

/*
 *   GET请求
 */
+ (void)GetUrlString:(NSString *)UrlString parametersDictionary:(NSDictionary *)dict successBlock:(successBlock)successBlock failureBlock:(failureBlock)failureBlock{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
 
    [manager.requestSerializer setValue:GetToken forHTTPHeaderField:@"Authorization"];
    
    
//    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
    
    
    
    //    manager.securityPolicy.allowInvalidCertificates = YES;
    //    manager.securityPolicy.validatesDomainName = NO;
    
    [manager GET:UrlString parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(task,responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(task,error);
    }];
    
}

/*
 *  POST请求
 */
+ (void)POSTUrlString:(NSString *)UrlString parametersDictionary:(NSDictionary *)dict successBlock:(successBlock)successBlock failureBlock:(failureBlock)failureBlock{
   
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if (GetToken) {
      [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",GetToken] forHTTPHeaderField:@"Authorization"];
    }
    
    
    [manager.requestSerializer setValue:CRAppVersionShort forHTTPHeaderField:@"user-agent2"];    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    
    [manager POST:UrlString parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(task,responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(task,error);
    }];


    
}

@end
