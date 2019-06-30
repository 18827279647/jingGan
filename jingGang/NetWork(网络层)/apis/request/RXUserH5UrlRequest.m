//
//  RXUserH5UrlRequest.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/28.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXUserH5UrlRequest.h"
#import "RXUserH5UrlResponse.h"

@implementation RXUserH5UrlRequest

- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    [self.queryParameters setValue:self.code forKey:@"code"];
    return self.queryParameters;
}
- (NSMutableDictionary *) getPathParameters
{
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return RXUserH5UrlResponse.class;
}
- (NSString *) getApiUrl
{
    NSString*url=[NSString stringWithFormat:@"%@/v1/hp/userH5Url",self.baseUrl];
    return url;
}

@end
