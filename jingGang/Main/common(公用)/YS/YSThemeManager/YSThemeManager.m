//
//  YSThemeManager.m
//  jingGang
//
//  Created by dengxf on 16/12/30.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSThemeManager.h"
#import "GlobeObject.h"
#define kAppThemeColorValuesKey  @"kAppThemeColorValuesKey"

@interface YSThemeManager ()

@end

@implementation YSThemeManager

+ (BOOL)isNormal {
    NSNumber *themeNumber = [self achieve:kAppThemeColorValuesKey];
    switch ([themeNumber integerValue]) {
        case YSAppThemeNormalType:
            return YES;
            break;
        case YSAppThemeNewYearType:
            return NO;
            break;
        default:
            return YES;
            break;
    }
    return YES;
}

+ (void)settingAppThemeType:(YSAppThemeType)themeType {
    [self save:[NSNumber numberWithInteger:themeType] key:kAppThemeColorValuesKey];
}

+ (UIColor *)getTableViewLineColor{
    return UIColorFromRGB(0xf0f0f0);
}

+ (YSThemeColor)themeColor
{
    UIColor *color;
    switch ([[self achieve:kAppThemeColorValuesKey] integerValue]) {
        case YSAppThemeNormalType:
        {
            // normal
            return COMMONTOPICCOLOR;
        }
            break;
        case YSAppThemeNewYearType:
        {
            // newYear
            return [UIColor colorWithHexString:@"65BBB1"];
        }
            break;
        default:
        {
            // normal
            return COMMONTOPICCOLOR;
        }
            break;
    }
    return color;
}

+ (YSButtonBgColor)buttonBgColor {
    UIColor *color;
    switch ([[self achieve:kAppThemeColorValuesKey] integerValue]) {
        case YSAppThemeNormalType:
        {
            
            return [UIColor colorWithHexString:@"65BBB1"];
        }
            break;
        case YSAppThemeNewYearType:
        {
            return COMMONTOPICCOLOR;
        }
            break;
        default:
            return COMMONTOPICCOLOR;
            break;
    }
    return color;
}

+ (YSPriceColor)priceColor {
    UIColor *color;
    switch ([[self achieve:kAppThemeColorValuesKey] integerValue]) {
        case YSAppThemeNormalType:
        {
            
            return [UIColor colorWithHexString:@"FF5C44"];
        }
            break;
        case YSAppThemeNewYearType:
        {
            return [UIColor colorWithHexString:@"FF5C44"];
        }
            break;
        default:
            return [UIColor colorWithHexString:@"FF5C44"];
            break;
    }
    return color;
}

+ (YSFavourableColor)favourableColor {
    UIColor *color;
    switch ([[self achieve:kAppThemeColorValuesKey] integerValue]) {
        case YSAppThemeNormalType:
        {
            
            return [UIColor colorWithHexString:@"FD9436"];
        }
            break;
        case YSAppThemeNewYearType:
        {
            return [UIColor colorWithHexString:@"FD9436"];
        }
            break;
        default:
            return [UIColor colorWithHexString:@"FD9436"];
            break;
    }
    return color;
}

+ (void)setNavigationTitle:(NSString *)navTitle andViewController:(UIViewController *)viewController{
    CGFloat titleViewWidth = 0.0;
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleViewWidth, 35)];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.font = JGRegularFont(18.0);
    titleLable.text = navTitle;
    titleLable.textAlignment = NSTextAlignmentCenter;
    viewController.navigationItem.titleView = titleLable;
}
+ (void)setNavigationSearch:(NSString *)placeholder andViewController:(UIViewController *)viewController{
    CGFloat titleViewWidth = 0.0;
//    UITextField *titleLable = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, titleViewWidth, 35)];
//    titleLable.textColor = [UIColor whiteColor];
//    titleLable.font = JGRegularFont(18.0);
//    titleLable.text = placeholder;
//    titleLable.textAlignment = NSTextAlignmentCenter;
//
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, titleViewWidth, 35);
    [searchButton setImage:[UIImage imageNamed:@"sousuo_hui"] forState:UIControlStateNormal];
    [searchButton setTitle:@"请输入您感兴趣的商户或服务名称" forState:UIControlStateNormal];
    searchButton.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
//    searchButton.centerY = self.searchBgView.centerY;
    searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
    searchButton.layer.cornerRadius = searchButton.height/2;
    searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [searchButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    viewController.navigationItem.titleView = searchButton;
}
+ (UIImage *)getNavgationBackButtonImage{
    UIImage *backImage = [UIImage imageNamed:@"navigationBarBack"];
    return backImage;
}

// 拨打电话
+ (void)callPhone:(NSString *)phoneNum {
    
    if (phoneNum.length == 0) {
        return;
    }
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phoneNum];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    });
}

@end
