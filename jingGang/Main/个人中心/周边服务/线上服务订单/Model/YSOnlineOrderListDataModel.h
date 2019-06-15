//
//  YSOnlineOrderListDataModel.h
//  jingGang
//
//  Created by HanZhongchou on 2017/4/13.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupService.h"
@interface YSOnlineOrderListDataModel : NSObject
//id
@property (nonatomic, copy) NSNumber *id;
//服务图片
@property (nonatomic, copy) NSString *groupAccPath;
//服务名称
@property (nonatomic, copy) NSString *ggName;
//总价
@property (nonatomic, copy) NSNumber *totalPrice;
//状态|默认为0，使用后为1，过期为-1
@property (nonatomic, readonly, copy) NSNumber *status;

@property (nonatomic, copy) NSNumber *orderStatus;
//商品数量
@property (nonatomic, copy) NSNumber *goodsCount;
//groupInfo
@property (nonatomic, copy) NSString *groupInfo;
//服务信息
@property (nonatomic, copy) GroupService *service;
//线下服务名称
@property (nonatomic, copy) NSString *localGroupName;
//订单类型
@property (nonatomic,copy) NSNumber *orderType;
//原价
@property (nonatomic,copy) NSNumber *originalPrice;
//商店ID
@property (nonatomic,copy) NSNumber *storeId;

@end
