//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"

@interface UsersMobileIsBindResponse :  AbstractResponse
//Cn账号是否绑定手机账号
@property (nonatomic, readonly, copy) NSNumber *isBindMobile;
//是否是CN账号
@property (nonatomic, readonly, copy) NSNumber *isCn;
//是否需要重新登录标识
@property (nonatomic, readonly, copy) NSNumber *isLogin;
@end
