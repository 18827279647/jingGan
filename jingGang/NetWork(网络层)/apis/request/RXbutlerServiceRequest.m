//
//  RXbutlerServiceRequest.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/25.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXbutlerServiceRequest.h"

@implementation RXbutlerServiceRequest

- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    [self.queryParameters setValue:@"16000" forKey:@"goodsId"];
    return self.queryParameters;
}
- (NSMutableDictionary *) getPathParameters
{
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return RXbutlerServiceResponse.class;
}
- (NSString *) getApiUrl
{
    
    NSString*url=[NSString stringWithFormat:@"%@/v1/goods/details",self.baseUrl];
    return url;
}

@end
