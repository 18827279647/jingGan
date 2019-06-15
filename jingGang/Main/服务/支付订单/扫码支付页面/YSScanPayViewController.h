//
//  YSScanPayViewController.h
//  jingGang
//
//  Created by HanZhongchou on 2017/1/4.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "XK_ViewController.h"
#import "DefineEnum.h"

/*** 选择的支付方式*/
typedef NS_ENUM(NSUInteger, YSSelectPayType) {
    /***  微信*/
    YSWeChatPayType = 0,
    /***  支付宝 */
    YSAliPayType = 1,
    /***  健康豆 */
    YSCloudMoneyPayType = 2,
    /***  未知支付方式 */
    YSUnknownPayType
};


@interface YSScanPayViewController : XK_ViewController
/**
 *  支付类型
 */
@property (nonatomic, assign)JingGangPay jingGangPay;
/**
 *  订单ID
 */
@property (nonatomic,copy) NSNumber *orderID;
/**
 *  订单编号
 */
@property (nonatomic,copy) NSString *strOrderNum;
/**
 *  折扣
 */
@property (nonatomic,assign) CGFloat discount;
/**
 *  输入的价格
 */
@property (nonatomic,assign) CGFloat inputPrice;

@property (assign, nonatomic) YSSelectPayType selectPayType;

@end
