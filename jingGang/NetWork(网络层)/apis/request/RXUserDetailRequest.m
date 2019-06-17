//
//  RXUserDetailRequest.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXUserDetailRequest.h"

@implementation RXUserDetailRequest

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
    return RXUserDetailResponse.class;
}

- (NSString *) getApiUrl
{
    NSString*url=[NSString stringWithFormat:@"%@/v1/hp/userDetail",self.baseUrl];
    return url;
}

@end
