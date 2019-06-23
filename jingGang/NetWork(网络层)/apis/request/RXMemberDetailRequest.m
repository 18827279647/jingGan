//
//  RXMemberDetailRequest.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/23.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXMemberDetailRequest.h"
#import "RXMemberDetailResponse.h"

@implementation RXMemberDetailRequest

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
    return RXMemberDetailResponse.class;
}

- (NSString *) getApiUrl
{
    //    NSString*url=[NSString stringWithFormat:@"%@/v1/hp/userDetail",self.baseUrl];
    NSString*url=[NSString stringWithFormat:@"http://192.168.8.160:8080/carnation-apis-resource//v1/hp/getMemberDetail"];
    return url;
}
@end
