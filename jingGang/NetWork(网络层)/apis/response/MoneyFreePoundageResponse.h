//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"

@interface MoneyFreePoundageResponse :  AbstractResponse
//免费提现余额
@property (nonatomic, readonly, copy) NSNumber *freePoundage;
//当月提现次数
@property (nonatomic, readonly, copy) NSNumber *line;
@end
