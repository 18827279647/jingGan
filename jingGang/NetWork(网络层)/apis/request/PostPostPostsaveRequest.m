//
//  AppInitRequest.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "PostPostPostsaveRequest.h"

@implementation PostPostPostsaveRequest



- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    [self.queryParameters setValue:[self.api_userId stringValue] forKey:@"userId"];
    [self.queryParameters setValue:self.api_location forKey:@"location"];
    [self.queryParameters setValue:self.api_title forKey:@"title"];
    [self.queryParameters setValue:self.api_content forKey:@"content"];
    [self.queryParameters setValue:self.api_labelName forKey:@"labelName"];
    [self.queryParameters setValue:self.api_thumbnail forKey:@"thumbnail"];
    [self.queryParameters setValue:self.api_labelIds forKey:@"labelIds"];
    return self.queryParameters;
}

- (NSMutableDictionary *) getPathParameters
{
    
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return PostPostPostsaveResponse.class;
}

- (NSString *) getApiUrl
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/post/post_postsave",self.baseUrl];
    return url;
}

@end
