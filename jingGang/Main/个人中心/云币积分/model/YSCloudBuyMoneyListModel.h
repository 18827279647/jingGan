//
//  YSCloudBuyMoneyListModel.h
//  jingGang
//
//  Created by HanZhongchou on 16/9/8.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSCloudBuyMoneyListModel : NSObject

/**
 *  云购币变动数值
 */
@property (nonatomic,copy) NSString *usedRepeatMoney;
/**
 *  1奖金 3云购币
 */
@property (nonatomic, assign) NSInteger payType;
/**
 *  奖金变动数值
 */
@property (nonatomic, copy) NSString *usedBonusPrice;
/**
 *  0购物 1 退款
 */
@property (nonatomic, assign) NSInteger type;
/**
 *  添加时间
 */
@property (nonatomic, copy) NSString *dateTime;



@end
