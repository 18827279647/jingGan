//
//  AppInitRequest.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "ShopTradeYgPaymetResponse.h"

@interface ShopTradeYgPaymetRequest : AbstractRequest
/** 
 * 支付方式:  alipay_app,wx_app
 */
@property (nonatomic, readwrite, copy) NSString *api_paymentType;
/** 
 * 主订单 id
 */
@property (nonatomic, readwrite, copy) NSNumber *api_mainOrderId;
/** 
 * 是否用户健康豆支付
 */
@property (nonatomic, readwrite, copy) NSNumber *api_isUserMoneyPaymet;
/** 
 * 用户支付密码，如果为健康豆支付该密码不能为空
 */
@property (nonatomic, readwrite, copy) NSString *api_paymetPassword;
/** 
 * 类型：1商城支付；2服务支付；3积分兑换支付
 */
@property (nonatomic, readwrite, copy) NSNumber *api_type;
/** 
 * 是否使用云购币支付
 */
@property (nonatomic, readwrite, copy) NSNumber *api_isYunGouMoney;
/** 
 * 是否使用奖金支付/保留字段不用管true/false
 */
@property (nonatomic, readwrite, copy) NSNumber *api_isBonusPay;
/** 
 * 云购币密码;;; 如果使用云购币 ,密码不能为空
 */
@property (nonatomic, readwrite, copy) NSString *api_bonusYunGouPwd;
/** 
 * jj;cz;cash
 */
@property (nonatomic, readwrite, copy) NSString *api_payType;
/** 
 * 已支付云购币
 */
@property (nonatomic, readwrite, copy) NSString *api_actualygPrice;
/** 
 * 已支付现金
 */
@property (nonatomic, readwrite, copy) NSString *api_actualPrice;
@end
