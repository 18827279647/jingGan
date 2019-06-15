//
//  JingXuanClassRespone.m
//  jingGang
//
//  Created by whlx on 2019/1/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "JingXuanClassRespone.h"

@implementation JingXuanClassRespone
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
             @"goodsClassList":@"goodsClassList",
             };
}
+(NSValueTransformer *) goodsCaseListTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[GoodsCase class]];
}
+(NSValueTransformer *) goodsListTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[Goods class]];
}
+(NSValueTransformer *) goodsClassListTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[GoodsClass class]];
}
+(NSValueTransformer *) goodsLikeListTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[Goods class]];
}
+(NSValueTransformer *) storeInfoTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[ShopStore class]];
}
+(NSValueTransformer *) youLikelistTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[Goods class]];
}
@end
