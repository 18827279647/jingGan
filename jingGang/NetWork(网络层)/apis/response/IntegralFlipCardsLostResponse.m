//
//  AppInitResponse.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IntegralFlipCardsLostResponse.h"

@implementation IntegralFlipCardsLostResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
			@"ifSenior":@"ifSenior",
			@"ifFlip":@"ifFlip",
			@"signDayFlip":@"signDayFlip",
			@"ifRemedy":@"ifRemedy",
			@"ytdSignDay":@"ytdSignDay",
			@"flipIntegral":@"flipIntegral",
			@"remedy":@"remedy"
             };
}

@end
