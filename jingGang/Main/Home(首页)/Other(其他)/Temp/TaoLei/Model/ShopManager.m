//
//  TLOrderManager.m
//  jingGang
//
//  Created by thinker on 15/8/24.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "ShopManager.h"
#import "GoodsManager.h"

@implementation ShopManager

- (void)getGoodsWithGoodsCartList:(NSArray *)goodsCartList
{
    self.goodsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < goodsCartList.count; i++) {
        NSDictionary *goodsCart = goodsCartList[i];
        GoodsManager *goods = [[GoodsManager alloc] initWithGoodsInfo:goodsCart];
        [self.goodsArray addObject:goods];
    }
}

- (id)initWithShopStore:(NSDictionary *)shopStore;
{
    if (self = [super init]) {
        self.shopName = shopStore[@"storeName"];
        if (self.shopName ==  nil) {
            self.shopName = @"平台自营";
        } else {
            
        }
    }
    
    return self;
}

- (void)setIsHasYunGouBiZone:(BOOL)isHasYunGouBiZone{
    _isHasYunGouBiZone = isHasYunGouBiZone;
    
    if (isHasYunGouBiZone) {
        self.shopName = @"精选专区";
    }

}

- (NSInteger)totalCount {
    NSInteger total = 0.0;
    for (int i = 0; i < self.goodsArray.count; i++) {
        GoodsManager *goodsInfo = self.goodsArray[i];
        total += goodsInfo.goodscount.integerValue;
    }
    return total;
}

- (void)setSeletedTransport:(NSString *)seletedTransport
{
    _seletedTransport = seletedTransport;
    float value = 0.0;
    NSCharacterSet* nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    value = [[seletedTransport stringByTrimmingCharactersInSet:nonDigits] floatValue];
    self.transportPrice = value;

}

- (void)setTransportWay:(NSArray *)transportWay
{
    _transportWay = transportWay;
    self.seletedTransport = transportWay.firstObject;
}

- (double)goodsRealPrice {
    _goodsRealPrice = 0.0;
    for (int i = 0; i < self.goodsArray.count; i++) {
        GoodsManager *goodsInfo = self.goodsArray[i];
        if (goodsInfo.isSelectedIntegral) {
            _goodsRealPrice += (goodsInfo.integralPrice.doubleValue * goodsInfo.goodscount.integerValue);
        } else {
            _goodsRealPrice += (goodsInfo.goodsCurrentPrice.doubleValue * goodsInfo.goodscount.integerValue);
        }
    }
    return _goodsRealPrice;
}
- (double)pdRealPrice {
    _pdRealPrice = 0.0;
    for (int i = 0; i < self.goodsArray.count; i++) {
        GoodsManager *goodsInfo = self.goodsArray[i];
        if (goodsInfo.isSelectedIntegral) {
            _pdRealPrice += (goodsInfo.pdPrice.doubleValue * goodsInfo.goodscount.integerValue);
        } else {
            _pdRealPrice += (goodsInfo.pdPrice.doubleValue * goodsInfo.goodscount.integerValue);
        }
    }
    return _pdRealPrice;
}

- (NSNumber *)totalPrice {
    double total = 0.0;
    if (self.isHasYunGouBiZone) {
        total = self.goodsRealPrice + self.transportPrice;
    }else{
        total = self.goodsRealPrice + self.transportPrice - self.youhuiVaule - self.hongbaoVaule;
    }
    
    return @(total);
}

- (NSNumber *)pdtotalPrice {
    double total = 0.0;
    if (self.isHasYunGouBiZone) {
        total = self.pdRealPrice + self.transportPrice;
    }else{
        total = self.pdRealPrice + self.transportPrice - self.youhuiVaule - self.hongbaoVaule;
    }
    
    return @(total);
}


@end
