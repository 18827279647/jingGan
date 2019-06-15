//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"
#import "SysVersionControlBO.h"

@interface VersionControlGetNewResponse :  AbstractResponse
//最新版本信息
@property (nonatomic, readonly, copy) SysVersionControlBO *sysVersionControlBO;
@end
