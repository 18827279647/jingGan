//
//  LJzhongxinRequest.m
//  jingGang
//
//  Created by whlx on 2019/3/12.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "LJzhongxinRequest.h"

@implementation LJzhongxinRequest
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
    return LJzhongxinResponse.class;
}

- (NSString *) getApiUrl
{
   NSString *url = [NSString stringWithFormat:@"%@/v1/goods/my_shopCoupon_center",self.baseUrl];

    return url;
}
@end
