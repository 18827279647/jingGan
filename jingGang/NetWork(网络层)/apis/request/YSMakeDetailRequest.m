//
//  YSMakeDetailRequest.m
//  jingGang
//
//  Created by whlx on 2019/5/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "YSMakeDetailRequest.h"
#import "YSMakeDetailResponse.h"
@implementation YSMakeDetailRequest
- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    [self.queryParameters setValue:self.uid  forKey:@"uid"];
    [self.queryParameters setValue:self.api_pageSize forKey:@"pageSize"];
    [self.queryParameters setValue:self.api_pageNum forKey:@"pageNum"];
    return self.queryParameters;
}

- (NSMutableDictionary *) getPathParameters
{
    
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return YSMakeDetailResponse.class;
}

- (NSString *) getApiUrl
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/redBalance",self.baseUrl];
    return url;
}

@end
