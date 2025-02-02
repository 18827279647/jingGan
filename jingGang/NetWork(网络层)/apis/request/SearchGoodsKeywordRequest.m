//
//  AppInitRequest.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "SearchGoodsKeywordRequest.h"

@implementation SearchGoodsKeywordRequest



- (NSMutableDictionary *) getHeaders
{
    
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
	[self.queryParameters setValue:[self.api_gcId stringValue] forKey:@"gcId"];
	[self.queryParameters setValue:self.api_orderBy forKey:@"orderBy"];
	[self.queryParameters setValue:self.api_orderType forKey:@"orderType"];
	[self.queryParameters setValue:[self.api_goodsBrandId stringValue] forKey:@"goodsBrandId"];
	[self.queryParameters setValue:self.api_goodsName forKey:@"goodsName"];
	[self.queryParameters setValue:self.api_storeName forKey:@"storeName"];
	[self.queryParameters setValue:self.api_properties forKey:@"properties"];
	[self.queryParameters setValue:[self.api_goodsType stringValue] forKey:@"goodsType"];
	[self.queryParameters setValue:self.api_goodsCod forKey:@"goodsCod"];
	[self.queryParameters setValue:self.api_goodsTransfee forKey:@"goodsTransfee"];
	[self.queryParameters setValue:[self.api_goodsInventory stringValue] forKey:@"goodsInventory"];
	[self.queryParameters setValue:self.api_keyword forKey:@"keyword"];
	[self.queryParameters setValue:[self.api_onlyCN stringValue] forKey:@"onlyCN"];
	[self.queryParameters setValue:self.api_queryGc forKey:@"queryGc"];
	[self.queryParameters setValue:[self.api_isTuangou stringValue] forKey:@"isTuangou"];
	[self.queryParameters setValue:[self.api_pageSize stringValue] forKey:@"pageSize"];
	[self.queryParameters setValue:[self.api_pageNum stringValue] forKey:@"pageNum"];
    [self.queryParameters setValue:[self.api_isJiFenGou stringValue] forKey:@"isJiFenGou"];
    [self.queryParameters setValue:[self.api_isPinDan stringValue] forKey:@"isPinDan"];

    return self.queryParameters;
}

- (NSMutableDictionary *) getPathParameters
{
    
    return self.pathParameters;
}
- (Class) getResponseClazz
{
    return SearchGoodsKeywordResponse.class;
}

- (NSString *) getApiUrl
{
     NSString *url = [NSString stringWithFormat:@"%@/v1/search/goods/keyword",self.baseUrl];

    return url;
}

@end
