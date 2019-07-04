//
//  RXUserlastmouthreportdetailRequest.m
//  jingGang
//
//  Created by 荣旭 on 2019/7/3.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXUserlastmouthreportdetailRequest.h"
#import "RXUserweeklyreportdetailResponse.h"

@implementation RXUserlastmouthreportdetailRequest


- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    [self.queryParameters setValue:self.itemCode forKey:@"itemCode"];
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
    NSString*url=[NSString stringWithFormat:@"%@/v1/hp/userlastmouthreportdetail",self.baseUrl];
    return url;
}

@end
