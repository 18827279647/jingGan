//
//  AppInitRequest.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "PersonalGroupOrderAllResponse.h"

@interface PersonalGroupOrderAllRequest : AbstractRequest
/** 
 * 状态|0已取消,10未付款20未使用,30已使用100退款|全部传nil，选择优惠买单与扫码支付传nil
 */
@property (nonatomic, readwrite, copy) NSNumber *api_status;
/** 
 * 订单类型1|线上订单2|扫码支付3|优惠买单4|套餐券5代金券 
 */
@property (nonatomic, readwrite, copy) NSNumber *api_orderType;
/** 
 * 每页记录数|必须
 */
@property (nonatomic, readwrite, copy) NSNumber *api_pageSize;
/** 
 * 页数|必须
 */
@property (nonatomic, readwrite, copy) NSNumber *api_pageNum;
@end
