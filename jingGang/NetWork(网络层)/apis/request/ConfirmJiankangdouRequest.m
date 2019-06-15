//
//  ConfirmJiankangdouRequest.m
//  jingGang
//
//  Created by whlx on 2019/4/23.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "ConfirmJiankangdouRequest.h"
#import "ConfirmJiankangdouResponse.h"
@implementation ConfirmJiankangdouRequest
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
    return ConfirmJiankangdouResponse.class;
}

- (NSString *) getApiUrl
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/newRed/confirmJiankangdouMessage",self.baseUrl];
     //NSString *url = [NSString stringWithFormat:@"%@/v1/newRed/confirmJiankangdouMessage",@"http://192.168.1.120:8080/carnation-apis-resource"];
    return url;
}


@end
