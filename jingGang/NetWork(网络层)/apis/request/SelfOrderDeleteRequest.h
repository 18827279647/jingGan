//
//  AppInitRequest.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "SelfOrderDeleteResponse.h"

@interface SelfOrderDeleteRequest : AbstractRequest
/** 
 * 订单id
 */
@property (nonatomic, readwrite, copy) NSNumber *api_orderId;
/** 
 * 卷皮订单
 */
@property (nonatomic, readwrite, copy) NSNumber *api_isJuanpiOrder;
@end
