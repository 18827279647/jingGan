//
//  AppInitRequest.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "PostPostReplyRequest.h"

@implementation PostPostReplyRequest



- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
	[self.queryParameters setValue:[self.api_postId stringValue] forKey:@"postId"];
	[self.queryParameters setValue:self.api_content forKey:@"content"];
	[self.queryParameters setValue:[self.api_toUserId stringValue] forKey:@"toUserId"];
	[self.queryParameters setValue:[self.api_pid stringValue] forKey:@"pid"];
    return self.queryParameters;
}

- (NSMutableDictionary *) getPathParameters
{
    
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return PostPostReplyResponse.class;
}

- (NSString *) getApiUrl
{
     NSString *url = [NSString stringWithFormat:@"%@/v1/post/post_reply",self.baseUrl];
    return url;
}

@end
