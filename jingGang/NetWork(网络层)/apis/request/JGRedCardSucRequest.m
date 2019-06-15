//
//  JGRedCardSucRequest.m
//  jingGang
//
//  Created by hlguo2 on 2019/4/25.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "JGRedCardSucRequest.h"
#import "JGRedCardSucResponse.h"

@implementation JGRedCardSucRequest

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
    return JGRedCardSucResponse.class;
}

- (NSString *) getApiUrl
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/users/customer/CoupRedInteger",self.baseUrl];
    //NSString *url = [NSString stringWithFormat:@"%@/v1/newRed/confirmJiankangdouMessage",@"http://192.168.1.120:8080/carnation-apis-resource"];
    return url;
}

@end
