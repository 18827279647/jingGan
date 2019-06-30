//
//  RXRXUserOtherRequest.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/29.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXUserOtherRequest.h"
#import "RXUserOtherResponse.h"

@implementation RXUserOtherRequest

- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    [self.queryParameters setValue:self.id forKey:@"id"];
    return self.queryParameters;
}
- (NSMutableDictionary *) getPathParameters
{
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return RXUserOtherResponse.class;
}
- (NSString *) getApiUrl
{
    NSString*url=[NSString stringWithFormat:@"%@/v1/hp/userotherreportdetail",self.baseUrl];
    return url;
}
@end
