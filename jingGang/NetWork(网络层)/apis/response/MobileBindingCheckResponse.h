//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"

@interface MobileBindingCheckResponse :  AbstractResponse
//判断是否绑定，0未绑定，1已绑定 0|1
@property (nonatomic, readonly, copy) NSNumber *binding;
//微信unionID
@property (nonatomic, readonly, copy) NSString *unionID;
@end
