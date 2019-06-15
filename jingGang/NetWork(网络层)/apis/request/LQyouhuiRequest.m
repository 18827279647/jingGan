//
//  LQyouhuiRequest.m
//  jingGang
//
//  Created by whlx on 2019/3/10.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "LQyouhuiRequest.h"

@implementation LQyouhuiRequest
- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    [self.queryParameters setValue:self.appId forKey:@"couponId"];
    return self.queryParameters;
}

- (NSMutableDictionary *) getPathParameters
{
    
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return LQyouhuiResponse.class;
}

- (NSString *) getApiUrl
{
       NSString *url = [NSString stringWithFormat:@"%@/v1/goods/recieveCoupon",self.baseUrl];

    return url;
}
@end
