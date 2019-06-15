//
//  YSThumbnailManager.m
//  jingGang
//
//  Created by dengxf on 17/4/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSThumbnailManager.h"

@implementation YSThumbnailManager

+ (NSString *)healthyCircleThumbnailPicUrlString:(NSString *)urlString picLayoutType:(YSHealthyCircleThumbnailLayoutType)layoutType
{
    switch (layoutType) {
        case YSHealthyCircleThumbnailLayoutOnlyOneType:
            return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_350x230"];
            break;
        case YSHealthyCircleThumbnailLayoutTwoColType:
            return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_170x170"];
            break;
        case YSHealthyCircleThumbnailLayoutThreeColType:
            return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_113x113"];
            break;
        default:
            break;
    }
}

+ (NSString *)healthyCircleThumbnailUserHeaderPhotoUrlString:(NSString *)urlString {
    if ([urlString containsString:@"wx.qlogo"]) {
        return urlString;
    }
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_40x40"];
}

+ (NSString *)healthyManagerSelfTestThumbnailPicUrlString:(NSString *)urlString {
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_329x183"];
}

+ (NSString *)healthyManagerHealthyInformationThumbnailPicUrlString:(NSString *)urlString {
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_97x65"];
}

+ (NSString *)personalCenterUserHeaderPhotoPicUrlString:(NSString *)urlString {
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_50x50"];
}

+ (NSString *)nearbyGoodStoreRecomondPicUrlString:(NSString *)urlString {
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_120x75"];
}

+ (NSString *)nearbyDistanceLessPicUrlString:(NSString *)urlString {
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_120x75"];
}

+ (NSString *)nearbyBannerPicUrlString:(NSString *)urlString {
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_375x200"];
}

+ (NSString *)nearbyMerchantDetailBannerPicUrlString:(NSString *)urlString {
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_375x242"];
}

+ (NSString *)nearbyMerchantDetailCouponPicUrlString:(NSString *)urlString {
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_120x75"];
}

+ (NSString *)shopBannerPicUrlString:(NSString *)urlString {
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_375x200"];
}

+ (NSString *)shopIntegralPicUrlString:(NSString *)urlString {
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_375x65"];
}

+ (NSString *)shopSpecialPricePicUrlString:(NSString *)urlString {
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_114x114"];
}

+ (NSString *)shopCompetitiveRecommondPicUrlString:(NSString *)urlString {
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_114x114"];
}

+ (NSString *)shopYouLikePicUrlString:(NSString *)urlString {
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_114x114"];
}

+ (NSString *)shopGoodsDetailBannerPicUrlString:(NSString *)urlString{
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_375x375"];
}

+ (NSString *)shopGoodsDetailHasYouLikePicUrlString:(NSString *)urlString{
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_140x140"];
}

+ (NSString *)shopGoodsDetailStoreLogoPicUrlString:(NSString *)urlString{
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_50x42"];
}

+ (NSString *)shopGoodsDetailAddShoppingCarViewGoodPicUrlString:(NSString *)urlString{
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_100x100"];
}

+ (NSString *)shopStoreDetailStoreLogoPicUrlString:(NSString *)urlString{
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_72x60"];
}

+ (NSString *)shopGoodsListPicUrlString:(NSString *)urlString{
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_102x102"];
}

+ (NSString *)shopShoppingCartGoodsPicUrlString:(NSString *)urlString{
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_88x88"];
}

+ (NSString *)shopConfirmOrderGoodsPicUrlString:(NSString *)urlString{
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_88x88"];
}

+ (NSString *)shopEliteZoneGoodsListPicUrlString:(NSString *)urlString{
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_168x168"];
}
+ (NSString *)nearbyPromoteSaleRecommendPicUrlString:(NSString *)urlString {
    return [self mutableString:[self transMutableString:urlString] byAppendingString:@"_120x75"];
}

+ (NSMutableString *)transMutableString:(NSString *)string {
    return [NSMutableString stringWithFormat:@"%@",string];
}

+ (NSString *)mutableString:(NSMutableString *)mutableString byAppendingString:(NSString *)string
{
    NSString *thumPic = [[mutableString stringByAppendingString:string] copy];
    return thumPic;
}


@end
