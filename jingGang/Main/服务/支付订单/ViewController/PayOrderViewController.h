//
//  PayOrderViewController.h
//  jingGang
//
//  Created by thinker on 15/8/13.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "DefineEnum.h"

@interface PayOrderViewController : UIViewController
@property (nonatomic,copy) NSNumber *orderID;
@property (nonatomic,copy) NSString * orderNumber;
@property (nonatomic,assign) CGFloat userMoneyPaymet;
@property (nonatomic,assign) CGFloat totalPrice;

@property (nonatomic, assign)JingGangPay jingGangPay;
//酒业订单详情跳转链接
@property (nonatomic,copy) NSString *orderDetailUrl;

//是否0元购商品, 只限从确认订单页面使用
@property (nonatomic,assign) BOOL isZeroBuyGoods;


@end
