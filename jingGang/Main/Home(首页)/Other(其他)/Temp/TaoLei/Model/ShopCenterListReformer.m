//
//  PropertyListReformer.m
//  jingGang
//
//  Created by thinker on 15/8/4.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "ShopCenterListReformer.h"
#import "APIManager.h"


@implementation ShopCenterListReformer

NSString * const shopDataKeyName = @"shopDataKeyName";
NSString * const shopDataKeyLogo = @"shopDataKeyLogo";
NSString * const shopDataKeyType = @"shopDataKeyType";

/**
 *  收货的地址的相关键值
 */
NSString * const addressKeyUsrName       = @"addressKeyUsrName";
NSString * const addressKeyUsrPhone      = @"addressKeyUsrPhone";
NSString * const addressKeyAddressDetail = @"addressKeyAddressDetail";
NSString * const addressKeyAddressID     = @"addressKeyAddressID";

/**
 *  订单的相关键值
 */
NSString * const orderKeyID                 = @"orderKeyID";
NSString * const orderKeyOrderID            = @"orderKeyOrderID";
NSString * const orderKeyStatus             = @"orderKeyStatus";
NSString * const orderKeyGoodsCount         = @"orderKeyGoodsCount";
NSString * const orderKeyTotalPrice         = @"orderKeyTotalPrice";
NSString * const orderKeyTransPrice         = @"orderKeyTransPrice";
NSString * const orderKeyReceiverName       = @"orderKeyReceiverName";
NSString * const orderKeyGoodsImageUrlArray = @"orderKeyGoodsImageUrlArray";
NSString * const orderIsJuanPiOrder         = @"orderKetIsJuanPiOrder";
NSString * const orderTypeFlagKey           = @"orderTypeFlag";
NSString * const isPindan           = @"isPindan";
NSString * const headImgPathArray           = @"headImgPathArray";
/**
 *  物流的相关键值
 */
NSString * const transKeyCompanyID  = @"transKeyCompanyID";
NSString * const transKeyShipCodeID = @"transKeyShipCodeID";

/**
 *  退货相关键值
 */
NSString * const returnGoodsKeyGoodsName   = @"returnGoodsKeyGoodsName";
NSString * const returnGoodsKeyStatus      = @"returnGoodsKeyStatus";
NSString * const returnGoodsKeyImagePath   = @"returnGoodsKeyImagePath";
NSString * const returnGoodsKeyOrderId     = @"returnGoodsKeyOrderId";
NSString * const returnGoodsKeyGoodsId     = @"returnGoodsKeyGoodsId";
NSString * const returnGoodsKeyGoodsGspIds = @"returnGoodsKeyGoodsGspIds";
NSString * const returnGoodsKeyReason      = @"returnGoodsKeyReason";
NSString * const returnGoodsKeyselfAddress = @"returnGoodsKeyselfAddress";
NSString * const returnGoodsKeyLogId       = @"returnGoodsKeyLogId";

- (NSDictionary *)getReturnDicfromData:(NSDictionary *)originData
{
    
    NSString *GoodsGspIds = @"";
    NSString *selfAddress = @"";
    if (originData[@"goodsGspIds"] != nil) {
        GoodsGspIds = originData[@"goodsGspIds"];
    }
    if (originData[@"selfAddress"] != nil) {
        selfAddress = originData[@"selfAddress"];
    }
    NSDictionary *result = @{
                             returnGoodsKeyImagePath: originData[@"goodsMainphotoPath"],
                             returnGoodsKeyGoodsName: originData[@"goodsName"],
                             returnGoodsKeyStatus: originData[@"goodsReturnStatus"],
                             returnGoodsKeyOrderId: originData[@"returnOrderId"],
                             returnGoodsKeyGoodsId: originData[@"goodsId"],
                             returnGoodsKeyGoodsGspIds: GoodsGspIds,
                             returnGoodsKeyReason: originData[@"returnContent"],
                             returnGoodsKeyselfAddress: selfAddress,
                             returnGoodsKeyLogId: originData[@"id"],
                             };
    
    return result;
}


+ (NSString *)getTransContextFromData:(NSDictionary *)originData
{
    NSString *resultData = [NSString stringWithFormat:@"%@ \n %@",
                            originData[@"context"],originData[@"time"]];
    return resultData;
}

- (NSDictionary *)getOrderDatafromData:(NSDictionary *)originData fromManager:(APIManager *)manager
{
    NSDictionary *resultData = nil;
    NSArray *goodsInfo = originData[@"goodsInfos"];
    NSInteger totalCount = 0;
    NSMutableArray *photoPaths = [[NSMutableArray alloc] init];
    
    for (NSDictionary *goodsDic in goodsInfo) {
        totalCount += ((NSNumber *)goodsDic[@"goodsCount"]).integerValue;
        NSString *goodsImageUrl = goodsDic[@"goodsMainphotoPath"];
        if (goodsImageUrl) {
            [photoPaths addObject:goodsImageUrl];
        }
        
    }
    
    
    //该地方取到的值为空(不知道为何,一直取不到值,你可以点击订单列表,查看数据详情,都有打印),这个是新加参惨,取的为用户头像,当用户头像为1时,该订单为可以邀请好友进行拼单.
    //该值为2时,以为这该订单拼单成功
    
    
    NSArray *userCustomer = originData[@"userCustomer"];
    NSLog(@"userCustomer%@",userCustomer);
    NSMutableArray *photoPaths1 = [[NSMutableArray alloc] init];
    for (NSDictionary *goodsDic in userCustomer) {
        NSString *headImgPathURl = goodsDic[@"headImgPath"];
         NSLog(@"headImgPathURl%@",headImgPathURl);
        if (headImgPathURl) {
            [photoPaths1 addObject:headImgPathURl];
             NSLog(@"photoPaths1%@",photoPaths1);
        }
    }
    
    NSString *expressCompanyId = originData[@"expressCompanyId"];
    NSString *shipCode = originData[@"shipCode"];
    if (originData[@"expressCompanyId"] == nil || originData[@"shipCode"] == nil) {
        expressCompanyId = @"";
        shipCode = @"";
    }

    //是否卷皮订单orderIsJuanPiOrder
    NSNumber *isJuanPiOrder = originData[@"juanpiOrder"];
    if (isJuanPiOrder == nil) {
        isJuanPiOrder = @0;
    }
    NSNumber *orderStatus = originData[@"orderStatus"];
    if (isJuanPiOrder.integerValue != 0) {
        //卷皮商品订单没有订单状态为保持统一性自己设定一个
        //是否可以删除
        NSNumber *isDeleteJuanPiOrder = originData[@"isDelete"];
        if (isDeleteJuanPiOrder.boolValue) {
            //可以删除设置订单状态110
            orderStatus = @110;
        }else{
            //不可以删除设置订单状态120
            orderStatus = @120;
        }
    }
    
    
    //收件人名称
    NSString *strReceivername = originData[@"receiverName"];
    if (!strReceivername) {
        strReceivername = @"";
    }
    
    
    //同样是新加参数,该值已取到,需要作为判断条件,在订单列表来判断该商品是否是拼单商品
    NSString * isPinDan = originData[@"isPindan"];
    if (!isPinDan) {
        isPinDan = @"";
    }
    
    
    
    
    NSString *strShipPrice = originData[@"shipPrice"];
    if (!strShipPrice) {
        strShipPrice = @"";
    }
    
    NSNumber *orderTypeFlag = (NSNumber *)originData[@"orderTypeFlag"];
    if (!orderTypeFlag) {//等于4就是酒业订单，如果为空给赋值9999
        orderTypeFlag = @9999;
    }
    
    
    resultData = @{
                   orderKeyID: originData[@"id"],
                   orderKeyOrderID: originData[@"orderId"],
                   orderKeyStatus: orderStatus,
                   orderKeyTotalPrice: originData[@"totalPrice"],
                   orderKeyReceiverName: strReceivername,
                   orderKeyTransPrice: strShipPrice,
                   orderKeyGoodsCount: @(totalCount),
                   orderKeyGoodsImageUrlArray: photoPaths.copy,
                   transKeyCompanyID: expressCompanyId,
                   transKeyShipCodeID: shipCode,
                   orderIsJuanPiOrder: isJuanPiOrder,
                   orderTypeFlagKey: orderTypeFlag,
                   isPindan:isPinDan,
                   headImgPathArray:photoPaths1.copy,
                   };
    NSLog(@"originData%@",originData);
    return resultData;
}


- (NSDictionary *)getAddressfromData:(NSDictionary *)originData fromManager:(APIManager *)manager
{
    NSDictionary *resultData = nil;
    
    //TODO:根据不同的数据model对数据进行封装
    resultData = [self getAddressfromData:originData];
    
    /*if ([manager isKindOfClass:<#(__unsafe_unretained Class)#>]) {
        <#statements#>
    }
    
    if ([manager isKindOfClass:<#(__unsafe_unretained Class)#>]) {
        <#statements#>
    }
    
    if ([manager isKindOfClass:<#(__unsafe_unretained Class)#>]) {
        <#statements#>
    }*/

    return resultData;
}

- (NSArray *)getshopStores:(NSArray *)orderListArray
{
    NSMutableArray *transList = [[NSMutableArray alloc] init];
    for (NSDictionary * transDic in orderListArray) {
        NSDictionary *shopStore = transDic[@"shopStore"];
        if (shopStore == nil) {
            shopStore = @{
                          @"id": @(0)
                          };
        }
        [transList addObject:shopStore];
    }
    return transList.copy;
}

- (NSArray *)getGoodsCartListList:(NSArray *)orderListArray
{
    NSMutableArray *transList = [[NSMutableArray alloc] init];
    for (NSDictionary * transDic in orderListArray) {
        [transList addObject:(NSArray *)transDic[@"goodsCartList"]];
    }
    return transList.copy;
}

- (NSArray *)getCouponInfoList:(NSArray *)orderListArray
{
    NSMutableArray *transList = [[NSMutableArray alloc] init];
    for (NSDictionary * transDic in orderListArray) {
        NSArray *couponInfoList = transDic[@"couponInfoList"];
        if (couponInfoList) {
            [transList addObject:couponInfoList];
        }
//        [transList addObject:(NSArray *)transDic[@"couponInfoList"]];
    }
    return transList.copy;
}


- (NSArray *)getredPackageInfoList:(NSArray *)orderListArray
{
    NSMutableArray *transList = [[NSMutableArray alloc] init];
    for (NSDictionary * transDic in orderListArray) {
        [transList addObject:(NSArray *)transDic[@"redPackageInfoList"]];
    }
    return transList.copy;
}

- (NSArray *)getTransList:(NSArray *)orderListArray
{
    NSMutableArray *transList = [[NSMutableArray alloc] init];
    for (NSDictionary * transDic in orderListArray) {
        [transList addObject:[self getShopData:(NSArray *)transDic[@"transList"] keyword:@"key"]];
    }
    return transList.copy;
}

- (NSArray *)getShopData:(NSArray *)shopArray keyword:(NSString *)key
{
    NSMutableArray *propertyList = [[NSMutableArray alloc] init];
    for (NSDictionary * transDic in shopArray) {
        [propertyList addObject:transDic[key]];
    }
    return propertyList.copy;
}

- (NSDictionary *)getAddressfromData:(NSDictionary *)originData
{
    NSString *strAreaInfo   = originData[@"areaInfo"];
    NSString *strTrueName   = originData[@"trueName"];
    NSString *strMobile     = originData[@"mobile"];
    NSString *strAreaName   = originData[@"areaName"];
    if (strAreaInfo.length > 0 && strTrueName .length > 0 && strMobile .length > 0 && strAreaName .length > 0) {
        return @{
                 addressKeyUsrName: [NSString stringWithFormat:@"%@",originData[@"trueName"]],
                 addressKeyUsrPhone: [NSString stringWithFormat:@"%@",originData[@"mobile"]],
                 addressKeyAddressDetail: [NSString stringWithFormat:@"%@ %@",originData[@"areaName"],originData[@"areaInfo"]],
                 addressKeyAddressID: originData[@"id"],
                 };
    }else{
        return nil;
    }
}
@end
