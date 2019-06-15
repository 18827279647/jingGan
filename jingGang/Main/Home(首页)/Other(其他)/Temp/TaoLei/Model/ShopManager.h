//
//  TLOrderManager.h
//  jingGang
//
//  Created by thinker on 15/8/24.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShopManager : NSObject

@property (nonatomic,copy) NSString *shopName;
@property (nonatomic,copy) NSString *seletedTransport;
@property (nonatomic,strong) UIImage *shop_icon;
@property (nonatomic,strong) NSNumber *totalPrice;
@property (nonatomic,strong) NSNumber *pdtotalPrice;
@property (nonatomic,assign) NSInteger totalCount;
@property (nonatomic,assign) CGFloat goodsRealPrice;
@property (nonatomic,assign) CGFloat pdRealPrice;
@property (nonatomic,assign) CGFloat transportPrice;
@property (nonatomic,assign) CGFloat youhuiVaule;
@property (nonatomic,assign) CGFloat hongbaoVaule;
@property (nonatomic) long youhuiId;
@property (nonatomic,copy) NSString * hongbaoId;
@property (nonatomic,assign) CGFloat jifengVaule;
//@property (nonatomic) NSString *feedBack;
@property (nonatomic) NSMutableArray *youhuiArray;
@property (nonatomic,assign) BOOL isHasYunGouBiZone;

/**
 *  运输方式
 */
@property (nonatomic) NSArray *transportWay;
/**
 *  运输方式对应的价格
 */
@property (nonatomic) NSArray *transportMoney;

@property (nonatomic) NSMutableArray *goodsArray;

- (id)initWithShopStore:(NSDictionary *)shopStore;
- (void)getGoodsWithGoodsCartList:(NSArray *)goodsCartList;


@end




