//
//  AppInitResponse.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "ShopCartGoodsDetailResponse.h"

@implementation ShopCartGoodsDetailResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
			@"cartList":@"cartList",
			@"cnCartList":@"cnCartList",
			@"ygbCartList":@"ygbCartList",
			@"cartListSize":@"cartListSize",
			@"cnCartListSize":@"cnCartListSize",
			@"ygbCartListSize":@"ygbCartListSize",
			@"gcId":@"gcId",
			@"totalPrice":@"totalPrice",
			@"orderList":@"orderList",
			@"userAddressAll":@"userAddressAll",
			@"defaultAddress":@"defaultAddress",
			@"trans":@"trans",
			@"shopCartSize":@"shopCartSize",
			@"allGoodsFree":@"allGoodsFree",
			@"freeShipAmount":@"freeShipAmount"
             };
}

+(NSValueTransformer *) cartListTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[ShopGoodsCart class]];
}
+(NSValueTransformer *) cnCartListTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[ShopGoodsCart class]];
}
+(NSValueTransformer *) ygbCartListTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[ShopGoodsCart class]];
}
+(NSValueTransformer *) orderListTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[ShopOrderListDetail class]];
}
+(NSValueTransformer *) userAddressAllTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[ShopUserAddress class]];
}
+(NSValueTransformer *) defaultAddressTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[ShopUserAddress class]];
}
+(NSValueTransformer *) transTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[Trans class]];
}
@end
