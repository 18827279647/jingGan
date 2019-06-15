//
//  AppInitRequest.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IntegralFlipCardsGetRequest.h"

@implementation IntegralFlipCardsGetRequest



- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    return self.queryParameters;
}

- (NSMutableDictionary *) getPathParameters
{
    
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return IntegralFlipCardsGetResponse.class;
}

- (NSString *) getApiUrl
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/integral/flip_cards_get",self.baseUrl];
    return url;
}

@end
