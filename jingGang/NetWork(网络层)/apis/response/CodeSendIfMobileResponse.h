//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"

@interface CodeSendIfMobileResponse :  AbstractResponse
//是否是平台用户  是 true /不是 false
@property (nonatomic, readonly, copy) NSNumber *isBinding;
@end
