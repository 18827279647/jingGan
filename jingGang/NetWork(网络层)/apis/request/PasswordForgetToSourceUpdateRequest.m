//
//  AppInitRequest.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "PasswordForgetToSourceUpdateRequest.h"

@implementation PasswordForgetToSourceUpdateRequest



- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
	[self.queryParameters setValue:self.api_mobile forKey:@"mobile"];
	[self.queryParameters setValue:self.api_password forKey:@"password"];
	[self.queryParameters setValue:self.api_verifyCode forKey:@"verifyCode"];
	[self.queryParameters setValue:self.api_source forKey:@"source"];
    return self.queryParameters;
}

- (NSMutableDictionary *) getPathParameters
{
    
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return PasswordForgetToSourceUpdateResponse.class;
}

- (NSString *) getApiUrl
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/password_forget_to_source/update",self.baseUrl];
    return url;
}

@end
