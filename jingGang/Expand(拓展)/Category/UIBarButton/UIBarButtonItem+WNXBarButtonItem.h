//
//  UIBarButtonItem+WNXBarButtonItem.h
//  WNXHuntForCity
//
//  Created by MacBook on 15/6/29.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (WNXBarButtonItem)

/**
 *  根据图片快速创建一个UIBarButtonItem，返回小号barButtonItem
 */
+ (UIBarButtonItem *)initWithNormalImage:(NSString *)image target:(id)target action:(SEL)action;

/**
 *根据图片快速创建一个UIBarButtonItem，返回大号barButtonItem
 */
+ (UIBarButtonItem *)initWithNormalImageBig:(NSString *)image target:(id)target action:(SEL)action;

/**
 *根据图片快速创建一个UIBarButtonItem，自定义大小
 */

+ (UIBarButtonItem *)initWithNormalImage:(NSString *)imgString showBage:(BOOL)bage number:(NSInteger)num target:(id)target action:(SEL)action width:(CGFloat)width height:(CGFloat)height ;
+ (UIBarButtonItem *)initWithNormalImage:(NSString *)image target:(id)target action:(SEL)action width:(CGFloat)width height:(CGFloat)height;


/**
 *根据文字快速创建一个UIBarButtonItem，自定义大小
 */
+ (UIBarButtonItem *)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;

#pragma mark - 靖港项目的返回按钮
+ (UIBarButtonItem *)initJingGangBackItemWihtAction:(SEL)action target:(id)target;


#pragma mark - 返回带空隙的barButtonItem
+ (UIBarButtonItem *)barButtonItemSpace:(NSInteger)itemSpace;


@end
