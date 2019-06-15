//
//  HZQRCodeCreater.m
//  生成二维码Demo
//
//  Created by HanZhongchou on 16/8/15.
//  Copyright © 2016年 HanZhongchou. All rights reserved.
//

#import "HZQRCodeCreater.h"

@implementation HZQRCodeCreater


+ (UIImage *)createrQRCodeWithStrUrl:(NSString *)strUrl withLengthSide:(CGFloat)lengthSide
{
    // 1. 实例化二维码滤镜
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2. 恢复滤镜的默认属性
    
    [filter setDefaults];
    
    // 3. 将字符串转换成
    
    NSData *data = [strUrl dataUsingEncoding:NSUTF8StringEncoding];
    
    // 4. 通过KVO设置滤镜inputMessage数据
    
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5. 获得滤镜输出的图像
    
    CIImage *outputImage = [filter outputImage];
    
    // 6. 因为自动生成的CIImage比较模糊，这里自动重绘一遍再 转换成UIImage返回
    //    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];
    
    CGRect extent = CGRectIntegral(outputImage.extent);
    CGFloat scale = MIN(lengthSide/CGRectGetWidth(extent), lengthSide/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}



//- (UIImage *)loadQRCodeWithStr:(NSString *)str withSize:(CGFloat)size
//{
//    // 1. 实例化二维码滤镜
//    
//    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//    
//    // 2. 恢复滤镜的默认属性
//    
//    [filter setDefaults];
//    
//    // 3. 将字符串转换成
//    
//    NSData *data = [strUrl dataUsingEncoding:NSUTF8StringEncoding];
//    
//    // 4. 通过KVO设置滤镜inputMessage数据
//    
//    [filter setValue:data forKey:@"inputMessage"];
//    
//    // 5. 获得滤镜输出的图像
//    
//    CIImage *outputImage = [filter outputImage];
//    
//    // 6. 因为自动生成的CIImage比较模糊，这里自动重绘一遍再 转换成UIImage返回
//    //    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];
//}
//
//
//- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
//{
//    CGRect extent = CGRectIntegral(image.extent);
//    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
//    // 1.创建bitmap;
//    size_t width = CGRectGetWidth(extent) * scale;
//    size_t height = CGRectGetHeight(extent) * scale;
//    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
//    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
//    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
//    CGContextScaleCTM(bitmapRef, scale, scale);
//    CGContextDrawImage(bitmapRef, extent, bitmapImage);
//    // 2.保存bitmap到图片
//    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
//    CGContextRelease(bitmapRef);
//    CGImageRelease(bitmapImage);
//    return [UIImage imageWithCGImage:scaledImage];
//}



@end
