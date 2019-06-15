//
//  AppInitRequest.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "ShopJuanpiShareResponse.h"

@interface ShopJuanpiShareRequest : AbstractRequest
/** 
 * 商品Id
 */
@property (nonatomic, readwrite, copy) NSNumber *api_goodsId;
@end
