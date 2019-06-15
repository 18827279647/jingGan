//
//  AppInitRequest.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "VerifyCodeSendRequest.h"

@implementation VerifyCodeSendRequest



- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
	[self.queryParameters setValue:self.api_mobile forKey:@"mobile"];
    [self.queryParameters setValue:self.api_code forKey:@"code"];
    return self.queryParameters;
}

- (NSMutableDictionary *) getPathParameters
{
    
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return VerifyCodeSendResponse.class;
}

- (NSString *) getApiUrl
{
//    self.baseUrl = @"http://192.168.1.35:8084";
    
     NSString *url = [NSString stringWithFormat:@"%@/v1/verify_code/send",self.baseUrl];
    return url;
}

@end
