//
//  PindanSuccessRequest.m
//  jingGang
//
//  Created by whlx on 2019/4/24.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "PindanSuccessRequest.h"
#import "PindanSuccessResponse.h"
@implementation PindanSuccessRequest
- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    [self.queryParameters setValue:self.api_id  forKey:@"orderId"];
    return self.queryParameters;
}

- (NSMutableDictionary *) getPathParameters
{
    
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return PindanSuccessResponse.class;
}

- (NSString *) getApiUrl
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/goods/pindanSuccess",self.baseUrl];
    return url;
}

@end
