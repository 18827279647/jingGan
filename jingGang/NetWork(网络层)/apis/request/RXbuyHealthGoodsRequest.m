//
//  RXbuyHealthGoodsRequest.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/25.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXbuyHealthGoodsRequest.h"

@implementation RXbuyHealthGoodsRequest

- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    [self.queryParameters setValue:self.goodsId forKey:@"goodsId"];
    [self.queryParameters setValue:self.count forKey:@"count"];
    [self.queryParameters setValue:self.gsp forKey:@"gsp"];
    [self.queryParameters setValue:self.areaId forKey:@"areaId"];
    return self.queryParameters;
}
- (NSMutableDictionary *) getPathParameters
{
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return RXbuyHealthGoodsResponse.class;
}
- (NSString *) getApiUrl
{
    NSString*url=[NSString stringWithFormat:@"%@/v1/health/buyHealthGoods",self.baseUrl];
    return url;
}

@end
