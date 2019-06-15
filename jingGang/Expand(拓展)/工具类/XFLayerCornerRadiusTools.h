//
//  XFLayerCornerRadiusTools.h
//  jingGang
//
//  Created by dengxf on 17/5/3.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XFLayerCornerRadiusTools : NSObject

/** 切割UIView、UIButton和UILabel圆角
 * @param view 需要进行切割的对象
 * @param direction 切割的方向
 * @param cornerRadii 圆角半径
 * @param borderWidth 边框宽度
 * @param borderColor 边框颜色
 * @param backgroundColor 背景色
 */
+ (void)cuttingView:(UIView *)view cuttingDirection:(UIRectCorner)direction cornerRadii:(CGFloat)cornerRadii borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)backgroundColor;

/** 切割UIImageView圆角
 * @param imageView 需要进行切割的对象
 * @param direction 切割的方向
 * @param cornerRadii 圆角半径
 * @param borderWidth 边框宽度
 * @param borderColor 边框颜色
 * @param backgroundColor 背景色
 */
+ (void)cuttingImageView:(UIImageView *)imageView cuttingDirection:(UIRectCorner)direction cornerRadii:(CGFloat)cornerRadii borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)backgroundColor;

@end
