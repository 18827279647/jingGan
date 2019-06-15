//
//  JingXuanClassRequest.m
//  jingGang
//
//  Created by whlx on 2019/1/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "JingXuanClassRequest.h"
#import "JingXuanClassRespone.h"
@implementation JingXuanClassRequest
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
    return JingXuanClassRespone.class;
}


- (NSString *) getApiUrl
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/goods/jingxuan/seller/class",self.baseUrl];
    return url;
}
@end
