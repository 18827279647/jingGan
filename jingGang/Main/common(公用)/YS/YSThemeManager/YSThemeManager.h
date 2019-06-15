//
//  YSThemeManager.h
//  jingGang
//
//  Created by dengxf on 16/12/30.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "JGSingleton.h"

typedef NS_ENUM(NSUInteger, YSAppThemeType) {
    YSAppThemeNormalType = 0,
    YSAppThemeNewYearType,
};

typedef UIColor * YSThemeColor;
typedef UIColor * YSButtonBgColor;
typedef UIColor * YSPriceColor;
typedef UIColor * YSFavourableColor;

@interface YSThemeManager : JGSingleton

/**
 *  设置app版本主题 */
+ (void)settingAppThemeType:(YSAppThemeType)themeType;

/**
 *  统一顶部颜色 */
+ (YSThemeColor)themeColor;

/**
 *  统一按钮及按钮线条颜色 */
+ (YSButtonBgColor)buttonBgColor;

/**
 *  统一周边及商场价格颜色 */
+ (YSPriceColor)priceColor;

/**
 *  周边优惠买单价格、立即抢购颜色 */
+ (YSFavourableColor)favourableColor;

+ (BOOL)isNormal;
/**
 *  统一设置标题栏 */
+ (void)setNavigationTitle:(NSString *)title andViewController:(UIViewController *)viewController;
//设置搜索框
+ (void)setNavigationSearch:(NSString *)placeholder andViewController:(UIViewController *)viewController;
/**
 *  拨打电话 */
+ (void)callPhone:(NSString *)phoneNum;
/**
 *  统一设置tabelView分割线颜色 */
+ (UIColor *)getTableViewLineColor;

+ (UIImage *)getNavgationBackButtonImage;
@end
