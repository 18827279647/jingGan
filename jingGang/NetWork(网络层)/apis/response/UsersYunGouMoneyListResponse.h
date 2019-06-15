//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"
#import "UserYunGouMoney.h"

@interface UsersYunGouMoneyListResponse :  AbstractResponse
//用户云购币明细
@property (nonatomic, readonly, copy) NSArray *userYunGouMoneyBO;
//用户云购币
@property (nonatomic, readonly, copy) NSNumber *yunGouMoney;
@end
