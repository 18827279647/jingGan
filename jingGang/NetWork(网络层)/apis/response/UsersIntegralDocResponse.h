//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"

@interface UsersIntegralDocResponse :  AbstractResponse
//积分|健康豆规则说明
@property (nonatomic, readonly, copy) NSString *specContent;
@end
