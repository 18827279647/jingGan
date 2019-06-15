//
//  PoundageAndTaxRequest.m
//  Operator_JingGang
//
//  Created by whlx on 2019/4/16.
//  Copyright © 2019年 Dengxf. All rights reserved.
//

#import "PoundageAndTaxRequest.h"
#import "PoundageAndTaxResponse.h"
@implementation PoundageAndTaxRequest
- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    
    [self.queryParameters setValue:self.cashAmount  forKey:@"cashAmount"];
    
    return self.queryParameters;
}

- (NSMutableDictionary *) getPathParameters
{
    
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return PoundageAndTaxResponse.class;
}

- (NSString *) getApiUrl
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/cloud/buyer/cash/getPoundageAndTax",self.baseUrl];
   // NSString *url = @"http://192.168.1.120:8080/carnation-apis-resource/v1/cloud/buyer/cash/getPoundageAndTax";
    return url;
}
@end
