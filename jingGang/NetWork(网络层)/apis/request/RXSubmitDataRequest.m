//
//  RXSubmitDataRequest.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/26.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXSubmitDataRequest.h"
#import "RXSubmitDataResponse.h"

@implementation RXSubmitDataRequest

- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    [self.queryParameters setValue:self.paramJson forKey:@"paramJson"];
    [self.queryParameters setValue:[NSString stringWithFormat:@"%d",self.paramCode] forKey:@"paramCode"];
    return self.queryParameters;
}
- (NSMutableDictionary *) getPathParameters
{
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return RXSubmitDataResponse.class;
}
- (NSString *) getApiUrl
{
    NSString*url=[NSString stringWithFormat:@"%@/v1/hp/submitData",self.baseUrl];
    return url;
}

@end
