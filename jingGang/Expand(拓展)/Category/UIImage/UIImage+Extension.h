//
//  UIImage+Extension.h
//  jingGang
//
//  Created by dengxf11 on 17/2/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color blurRadiusInPixels:(NSInteger)pixels size:(CGSize)size;

+ (UIImage *)image:(UIImage *)image blurRadiusInPixels:(NSInteger)pixels size:(CGSize)size;
/**
 *  将白底设置为透明 */
+ (UIImage *)imageToTransparent:(UIImage*) image;
@end
