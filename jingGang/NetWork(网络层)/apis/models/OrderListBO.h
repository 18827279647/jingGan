//
//  Role.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "Mantle.h"
#import "OrderBO.h"

@interface OrderListBO : MTLModel <MTLJSONSerializing>

	//订单id
	@property (nonatomic, readonly, copy) NSNumber *apiId;
	//订单编号，以igo开头
	@property (nonatomic, readonly, copy) NSString *igoOrderSn;
	//订单状态，0为已提交未付款，20为付款成功，30为已发货，40为已收货完成,-1为已经取消，此时不归还用户积分
	@property (nonatomic, readonly, copy) NSNumber *igoStatus;
	//总共消费积分
	@property (nonatomic, readonly, copy) NSNumber *igoTotalIntegral;
	//购物车运费
	@property (nonatomic, readonly, copy) NSNumber *igoTransFee;
	//订单中的商品数量
	@property (nonatomic, readonly, copy) NSNumber *goodsCount;
	//订单中的商品列表
	@property (nonatomic, readonly, copy) NSArray *orderBOList;
	
@end
