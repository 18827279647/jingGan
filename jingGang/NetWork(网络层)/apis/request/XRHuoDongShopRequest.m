//
//  XRHuoDongShopRequest.m
//  jingGang
//
//  Created by whlx on 2019/4/8.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "XRHuoDongShopRequest.h"
#import "XRHuoDongShopRespone.h"
@implementation XRHuoDongShopRequest
- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    [self.queryParameters setValue:self.api_pageSize forKey:@"pageSize"];
    [self.queryParameters setValue:self.api_pageNum forKey:@"pageNum"];
    return self.queryParameters;
}

- (NSMutableDictionary *) getPathParameters
{
    
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return XRHuoDongShopRespone.class;
}

- (NSString *) getApiUrl
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/newRed/newRedGoods",self.baseUrl];
   // NSString *url = [NSString stringWithFormat:@"http://192.168.1.120:8080/carnation-apis-resource/v1/newRed/newRedGoods"];
    return url;
}
@end
