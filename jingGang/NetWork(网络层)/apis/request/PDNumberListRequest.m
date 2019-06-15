//
//  PDNumberListRequest.m
//  jingGang
//
//  Created by whlx on 2019/4/10.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "PDNumberListRequest.h"
#import "PDNumberListResponse.h"
@implementation PDNumberListRequest
- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    [self.queryParameters setValue:self.api_goodsId forKey:@"goodsId"];
    return self.queryParameters;
}

- (NSMutableDictionary *) getPathParameters
{
    
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return PDNumberListResponse.class;
}

- (NSString *) getApiUrl
{
 NSString *url = [NSString stringWithFormat:@"%@/v1/goods/buyTogertherUsers",self.baseUrl];
//NSString *url = [NSString stringWithFormat:@"%@/v1/goods/buyTogertherUsers",@"http://192.168.1.120:8080/carnation-apis-resource"];
    return url;
}
@end
