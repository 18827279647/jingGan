//
//  AppInitRequest.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "ShopTradeCxPaymetRequest.h"

@implementation ShopTradeCxPaymetRequest



- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
	[self.queryParameters setValue:self.api_paymentType forKey:@"paymentType"];
	[self.queryParameters setValue:[self.api_mainOrderId stringValue] forKey:@"mainOrderId"];
	[self.queryParameters setValue:[self.api_isUserMoneyPaymet stringValue] forKey:@"isUserMoneyPaymet"];
	[self.queryParameters setValue:self.api_paymetPassword forKey:@"paymetPassword"];
	[self.queryParameters setValue:[self.api_type stringValue] forKey:@"type"];
	[self.queryParameters setValue:[self.api_isYunGouMoney stringValue] forKey:@"isYunGouMoney"];
	[self.queryParameters setValue:[self.api_isBonusPay stringValue] forKey:@"isBonusPay"];
	[self.queryParameters setValue:self.api_bonusYunGouPwd forKey:@"bonusYunGouPwd"];
	[self.queryParameters setValue:self.api_payType forKey:@"payType"];
	[self.queryParameters setValue:self.api_actualygPrice forKey:@"actualygPrice"];
	[self.queryParameters setValue:self.api_actualPrice forKey:@"actualPrice"];
	[self.queryParameters setValue:self.api_actualJfPrice forKey:@"actualJfPrice"];
    return self.queryParameters;
}

- (NSMutableDictionary *) getPathParameters
{
    
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return ShopTradeCxPaymetResponse.class;
}

- (NSString *) getApiUrl
{
     NSString *url = [NSString stringWithFormat:@"%@/v1/shop/trade/cx/paymet",self.baseUrl];
    return url;
}

@end
