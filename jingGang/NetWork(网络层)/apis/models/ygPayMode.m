//
//  Role.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "ygPayMode.h"

@implementation ygPayMode
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
			@"res":@"res",
			@"actualygPrice":@"actualygPrice",
			@"actualPrice":@"actualPrice",
			@"currentYgBalance":@"currentYgBalance",
			@"currentJjBalance":@"currentJjBalance",
			@"currentCzBalance":@"currentCzBalance",
			@"payMode":@"pay_mode",
			@"yGWalletStatus":@"yGWallet_status",
			@"jJWalletStatus":@"jJWallet_status",
			@"cZWalletStatus":@"cZWallet_status",
			@"currentIntegralBalance":@"currentIntegralBalance",
			@"actualIntegralBalance":@"actualIntegralBalance",
			@"payTypeFlag":@"payTypeFlag",
			@"currentBalance":@"currentBalance"
             };
}

@end
