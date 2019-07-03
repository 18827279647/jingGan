//
//  RXUserweeklyreportdetailRequest.m
//  jingGang
//
//  Created by 荣旭 on 2019/7/2.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXUserweeklyreportdetailRequest.h"
#import "RXUserweeklyreportdetailResponse.h"
@implementation RXUserweeklyreportdetailRequest

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
    return RXUserweeklyreportdetailResponse.class;
}
- (NSString *) getApiUrl
{
    NSString*url;
    if ([self.type isEqualToString:@"month"]) {
        url=[NSString stringWithFormat:@"%@/v1/hp/usermouthreportdetail ",self.baseUrl];
    }else{
        url=[NSString stringWithFormat:@"%@/v1/hp/userweeklyreportdetail",self.baseUrl];
    }
    return url;
}
@end
