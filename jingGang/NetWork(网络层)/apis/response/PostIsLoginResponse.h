//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"

@interface PostIsLoginResponse :  AbstractResponse
//是否登录:0未登录|1已登录
@property (nonatomic, readonly, copy) NSNumber *islogin;
@end
