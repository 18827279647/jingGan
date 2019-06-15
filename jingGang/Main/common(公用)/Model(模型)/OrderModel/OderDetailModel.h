//
//  OderDetailModel.h
//  jingGang
//
//  Created by 张康健 on 15/8/15.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "BaseModel.h"
#import "GoodsDetailModel.h"

@interface OderDetailModel : BaseModel
//id
@property (nonatomic,  copy) NSNumber *OderDetailModelID;
//订单号
@property (nonatomic,  copy) NSString *orderId;
//子订单
@property (nonatomic,  copy) NSString *childOrderDetail;
//订单状态  订单状态，0为订单取消，10为已提交待付款，15为线下付款提交申请，16为货到付款，,18待付款20为已付款待发货，30为已发货待收货，40为已收货，50买家评价完毕 ,65订单不可评价，到达设定时间，系统自动关闭订单相互评价功能
@property (nonatomic,  copy) NSNumber *orderStatus;
//配送价格
@property (nonatomic,  copy) NSNumber *shipPrice;
//商品信息
@property (nonatomic,  copy) GoodsDetailModel *goods;
//收货人姓名
@property (nonatomic,  copy) NSString *receiverName;
//收货人地区
@property (nonatomic,  copy) NSString *receiverArea;
//收货人详细地址
@property (nonatomic,  copy) NSString *receiverAreaInfo;
//商品信息
@property (nonatomic,  copy) NSArray *goodsInfos;
//订单商品详情 订单商品信息
@property (nonatomic,  copy) NSString *goodsInfo;
//商品总价格
@property (nonatomic,  copy) NSNumber *goodsAmount;

//订单总价
@property (nonatomic,  copy) NSNumber *totalPrice;
//订单实付总价
@property (nonatomic,  copy) NSNumber *price;
//下单时间
@property (nonatomic, copy)  NSString *addTime;
//收货人手机号码
@property (nonatomic,  copy) NSString *receiverMobile;
//订单对应店铺id
@property (nonatomic,  copy) NSString *storeId;
//订单对应店铺名称
@property (nonatomic,  copy) NSString *storeName;
//优惠券金额
@property (nonatomic,  copy) NSNumber *couponAmount;

//快递公司id
@property (nonatomic,  copy) NSNumber *expressCompanyId;
//物流单号
@property (nonatomic,  copy) NSString *shipCode;

//订单种类 0为商家，1为自营商品订单
@property (nonatomic, copy) NSNumber *orderForm;
//支付方式
@property (nonatomic,  copy) NSString *payWay;
#pragma mark - 订单状态
@property (nonatomic, copy)NSString *orderStatusStr;

#pragma mark - 是否可查看物流
@property (nonatomic,assign) BOOL canLookGoodsDelivery;

//云购币总和
@property (nonatomic, copy) NSNumber *allygPrice;
//云购产品现金总和
@property (nonatomic, copy) NSNumber *allCashPrice;
//云购币订单实际支付云购币
@property (nonatomic, copy) NSNumber *actualygPrice;
//云购币订单实际支付现金
@property (nonatomic, copy) NSNumber *actualPrice;
//佣金总费用/BV
@property (nonatomic, copy) NSNumber *commissionAmount;
//0普通 1零元购 2云购币[非专区] 3云购币专区
@property (nonatomic, copy) NSNumber *orderTypeFlag;
//1重消+现金 2积分+现金
@property (nonatomic, copy) NSNumber *payTypeFlag;
//实际支付积分
@property (nonatomic, copy) NSNumber *actualIntegral;
//订单需要积分总和
@property (nonatomic, copy) NSNumber *allIntegral;
//订单剩余时间
@property (nonatomic, copy) NSNumber *leftTime;

@property (nonatomic,copy)NSNumber *isPindan;
@property (nonatomic,  copy) NSArray *userCustomer;
@end
