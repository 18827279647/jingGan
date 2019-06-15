//
//  JGOrderRedDetailRequest.m
//  jingGang
//
//  Created by hlguo2 on 2019/4/25.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "JGOrderRedDetailRequest.h"
#import "JGOrderRedDetailSucResponse.h"

@implementation JGOrderRedDetailRequest


- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    [self.queryParameters setValue:self.api_orderId forKey:@"orderId"];
    return self.queryParameters;
}

- (NSMutableDictionary *) getPathParameters
{
    
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return JGOrderRedDetailSucResponse.class;
}

- (NSString *) getApiUrl
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/users/customer/orderRedDetail",self.baseUrl];
    // NSString *url = [NSString stringWithFormat:@"http://192.168.1.120:8080/carnation-apis-resource/v1/newRed/newRedGoods"];
    return url;
}


@end
