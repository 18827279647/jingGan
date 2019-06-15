//
//  AppInitResponse.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "ChunyuAccountSynResponse.h"

@implementation ChunyuAccountSynResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
             @"userId":@"userId",
             @"partner":@"partner",
             @"sign":@"sign",
             @"atime":@"atime",
             @"url":@"url",
             @"sessionid":@"sessionid",
             @"signUrl":@"signUrl"
             };
}


@end
