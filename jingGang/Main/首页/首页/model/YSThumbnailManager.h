//
//  YSThumbnailManager.h
//  jingGang
//
//  Created by dengxf on 17/4/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, YSHealthyCircleThumbnailLayoutType) {
    YSHealthyCircleThumbnailLayoutOnlyOneType = 1,
    YSHealthyCircleThumbnailLayoutTwoColType,
    YSHealthyCircleThumbnailLayoutThreeColType
};

/**
 *  项目缩略图管理 */
@interface YSThumbnailManager : NSObject

/**
 *  健康圈帖子 */
+ (NSString *)healthyCircleThumbnailPicUrlString:(NSString *)urlString picLayoutType:(YSHealthyCircleThumbnailLayoutType)layoutType;

/**
 *  健康圈用户头像 */
+ (NSString *)healthyCircleThumbnailUserHeaderPhotoUrlString:(NSString *)urlString;

/**
 *  健康自测 */
+ (NSString *)healthyManagerSelfTestThumbnailPicUrlString:(NSString *)urlString;

/**
 *  健康资讯 */
+ (NSString *)healthyManagerHealthyInformationThumbnailPicUrlString:(NSString *)urlString;

/**
 *  个人中心用户头像 */
+ (NSString *)personalCenterUserHeaderPhotoPicUrlString:(NSString *)urlString;

/**
 *  周边好店推荐 */
+ (NSString *)nearbyGoodStoreRecomondPicUrlString:(NSString *)urlString;

/**
 *  周边离我最近 */
+ (NSString *)nearbyDistanceLessPicUrlString:(NSString *)urlString;

/**
 *  周边banner图 */
+ (NSString *)nearbyBannerPicUrlString:(NSString *)urlString;

/**
 *  周边详情轮播图 */
+ (NSString *)nearbyMerchantDetailBannerPicUrlString:(NSString *)urlString;

/**
 *  周边详情代金券图 */
+ (NSString *)nearbyMerchantDetailCouponPicUrlString:(NSString *)urlString;

/**
 *  健康商城banner图 */
+ (NSString *)shopBannerPicUrlString:(NSString *)urlString;

/**
 *  商城积分图 */
+ (NSString *)shopIntegralPicUrlString:(NSString *)urlString;

/**
 *  商城特价 */
+ (NSString *)shopSpecialPricePicUrlString:(NSString *)urlString;

/**
 *  商城精品推荐 */
+ (NSString *)shopCompetitiveRecommondPicUrlString:(NSString *)urlString;

/**
 *  商城有你喜欢 */
+ (NSString *)shopYouLikePicUrlString:(NSString *)urlString;

/**
 *  商城商品详情-轮播图片 */
+ (NSString *)shopGoodsDetailBannerPicUrlString:(NSString *)urlString;

/**
 *  商城商品详情-猜你喜欢图片 */
+ (NSString *)shopGoodsDetailHasYouLikePicUrlString:(NSString *)urlString;

/**
 *  商城商品详情-商家logo图片 */
+ (NSString *)shopGoodsDetailStoreLogoPicUrlString:(NSString *)urlString;

/**
 *  商城商品详情-商品规格选择图片 */
+ (NSString *)shopGoodsDetailAddShoppingCarViewGoodPicUrlString:(NSString *)urlString;

/**
 *  商城店铺详情-logo图片 */
+ (NSString *)shopStoreDetailStoreLogoPicUrlString:(NSString *)urlString;

/**
 *  商城商品列表图片 */
+ (NSString *)shopGoodsListPicUrlString:(NSString *)urlString;

/**
 *  商城购物车商品图片 */
+ (NSString *)shopShoppingCartGoodsPicUrlString:(NSString *)urlString;

/**
 *  商城确定订单商品图 */
+ (NSString *)shopConfirmOrderGoodsPicUrlString:(NSString *)urlString;

/**
 *  商城精品专区商品列表 */
+ (NSString *)shopEliteZoneGoodsListPicUrlString:(NSString *)urlString;
/**
 *  服务详情猜你喜欢图片列表 */
+ (NSString *)nearbyPromoteSaleRecommendPicUrlString:(NSString *)urlString;

@end
