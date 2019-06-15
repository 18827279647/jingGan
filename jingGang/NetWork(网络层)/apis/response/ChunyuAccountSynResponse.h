//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"

@interface ChunyuAccountSynResponse :  AbstractResponse
//用户ID
@property (nonatomic, readonly, copy) NSNumber *userId;
//合作方
@property (nonatomic, readonly, copy) NSString *partner;
//签名字串
@property (nonatomic, readonly, copy) NSString *sign;
//时间戳
@property (nonatomic, readonly, copy) NSNumber *atime;
//登陆链接
@property (nonatomic, readonly, copy) NSString *url;
//登陆会话
@property (nonatomic, readonly, copy) NSString *sessionid;
//签名URL
@property (nonatomic, readonly, copy) NSString *signUrl;
@end
