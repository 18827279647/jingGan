//
//  AppInitRequest.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "PostPagePostListByUserIdRequest.h"

@implementation PostPagePostListByUserIdRequest



- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    [self.queryParameters setValue:[self.api_pageSize stringValue] forKey:@"pageSize"];
    [self.queryParameters setValue:[self.api_pageNum stringValue] forKey:@"pageNum"];
    [self.queryParameters setValue:[self.api_userId stringValue] forKey:@"userId"];
    return self.queryParameters;
}

- (NSMutableDictionary *) getPathParameters
{
    
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return PostPagePostListByUserIdResponse.class;
}

- (NSString *) getApiUrl
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/post/page_post_listByUserId",self.baseUrl];
    return url;
}

@end
