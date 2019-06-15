//
//  JGRedDetailRequest.m
//  jingGang
//
//  Created by hlguo2 on 2019/4/25.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "JGRedDetailRequest.h"
#import "JGRedDetailSucResponse.h"

@implementation JGRedDetailRequest

- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    [self.queryParameters setValue:self.api_pageSize forKey:@"pageSize"];
    [self.queryParameters setValue:self.api_pageNum forKey:@"pageNum"];
    [self.queryParameters setValue:self.api_type forKey:@"type"];
    return self.queryParameters;
}

- (NSMutableDictionary *) getPathParameters
{
    
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return JGRedDetailSucResponse.class;
}

- (NSString *) getApiUrl
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/users/customer/redDetail",self.baseUrl];
 // NSString *url = [NSString stringWithFormat:@"http://api.bhesky.com/v1/newRed/newRedGoods"];
    return url;
}

@end
