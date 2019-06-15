//
//  AnyiUI.h
//  DriverCimelia
//
//  Created by zw on 2017/3/29.
//  Copyright © 2017年 zw. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "NSString+Custom.h"
#import "UIView+Frame.h"

/**状态栏高度*/
#define RM_StateHeight [[UIApplication sharedApplication] statusBarFrame].size.height

/**导航栏高度*/
#define RM_NavHeigth (RM_StateHeight + kNavBarHeight)


//屏幕
#define SCREEMW [UIScreen mainScreen].bounds.size.width//屏幕宽度
#define SCREEMH [UIScreen mainScreen].bounds.size.height//屏幕高度

//字体
#define  Font(a)          [UIFont systemFontOfSize:a]
#define  BFont(a)         [UIFont boldSystemFontOfSize:a]
#define  PingFangMediumFont(a)    [UIFont systemFontOfSize:a]
#define  PingFangRegularFont(a)    [UIFont systemFontOfSize:a]
#define  PingFangLightFont(a)    [UIFont systemFontOfSize:a]
#define  PingFangSemiboldFont(a)    [UIFont boldSystemFontOfSize:a] 


//颜色
#define UIColorFromRGB(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//按钮类型
typedef enum : NSUInteger {
    ANYI_BUTTON_TYPE_NORMAL,//未指定类型
    ANYI_BUTTON_TYPE_YELLOW,//黄色
    ANYI_BUTTON_TYPE_WHITE,//白色按钮
} ANYI_BUTTON_TYPE;


@interface AnyiUI : NSObject

//label
+(UILabel *)CreateLbl:(CGRect)frame font:(UIFont *)font color:(UIColor *)color text:(NSString *)text align:(NSTextAlignment)align;
+(void)AddLabel:(CGRect)frame font:(UIFont *)font color:(UIColor *)color text:(NSString *)text align:(NSTextAlignment)align in:(UIView *)view;



//imageview
+(UIImageView *)CreateImg:(CGRect)frame name:(NSString *)name;
+(void)AddImg:(CGRect)frame name:(NSString *)name in:(UIView *)view;

//textfield
+(UITextField *)CreateTextField:(CGRect)frame font:(UIFont *)font color:(UIColor *)color align:(NSTextAlignment)align placeholder:(NSString *)placeholder isSecure:(BOOL)isSecure;

//arrow
+(void)AddArrowIn:(UIView *)view x:(CGFloat)x y:(CGFloat)y;
+(UIImageView *)CreateArrowx:(CGFloat)x y:(CGFloat)y;
//scroll
+(UIScrollView *)CreateScroll:(CGRect)frame;

//table
+(UITableView *)CreateTable:(CGRect)frame target:(id)target;

//添加视图
+(void)AddViewIn:(UIView *)view frame:(CGRect)frame color:(UIColor *)color;

//tableview 无数据空白页面
+(UIView *)GetNullFootView:(CGRect)frame;
//空视图
+(UIView *)GetNilView;


NSString* MBNonEmptyString(id obj);

@end
