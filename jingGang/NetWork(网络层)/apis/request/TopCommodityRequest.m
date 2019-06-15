//
//  TopCommodityRequest.m
//  jingGang
//
//  Created by whlx on 2019/4/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "TopCommodityRequest.h"
#import "TopCommodityResponse.h"
@implementation TopCommodityRequest
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
    return TopCommodityResponse.class;
}

- (NSString *) getApiUrl
{
       NSString *url = [NSString stringWithFormat:@"%@/v1/newRed/share",self.baseUrl];
    // NSString *url = [NSString stringWithFormat:@"http://192.168.1.120:8080/carnation-apis-resource/v1/newRed/share"];
    return url;
}
@end
