//
//  RXParamDetailRequest.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/20.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXParamDetailRequest.h"

@implementation RXParamDetailRequest

- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    [self.queryParameters setValue:self.paramCode forKey:@"paramCode"];
    [self.queryParameters setValue:self.id forKey:@"id"];
    return self.queryParameters;
}

- (NSMutableDictionary *) getPathParameters
{
    
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return RXParamDetailResponse.class;
}
- (NSString *) getApiUrl
{
    NSString*url=[NSString stringWithFormat:@"%@/v1/hp/getParamDetail",self.baseUrl];
    return url;
}

@end
