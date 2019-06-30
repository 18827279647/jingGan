//
//  RXAllParamDatasRequest.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/24.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXAllParamDatasRequest.h"
#import "RXAllParamDatasResponse.h"

@implementation RXAllParamDatasRequest

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
    return RXAllParamDatasResponse.class;
}

- (NSString *) getApiUrl
{
    NSString*url=[NSString stringWithFormat:@"%@/v1/hp/getAllParamDatas",self.baseUrl];
    return url;
}

@end
