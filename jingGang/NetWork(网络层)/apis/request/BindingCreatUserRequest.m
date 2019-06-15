//
//  AppInitRequest.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "BindingCreatUserRequest.h"

@implementation BindingCreatUserRequest



- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    [self.queryParameters setValue:self.api_InvitationCode forKey:@"InvitationCode"];
    [self.queryParameters setValue:self.api_openId forKey:@"openId"];
    [self.queryParameters setValue:self.api_unionId forKey:@"unionId"];
    [self.queryParameters setValue:[self.api_type stringValue] forKey:@"type"];
    return self.queryParameters;
}

- (NSMutableDictionary *) getPathParameters
{
    
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return BindingCreatUserResponse.class;
}

- (NSString *) getApiUrl
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/binding/creatUser",self.baseUrl];
    return url;
}

@end
