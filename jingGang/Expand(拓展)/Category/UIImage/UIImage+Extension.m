//
//  UIImage+Extension.m
//  jingGang
//
//  Created by dengxf11 on 17/2/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "UIImage+Extension.h"
#import "UIImage+YYAdd.h"
#import "GPUImage.h"
@implementation UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color blurRadiusInPixels:(NSInteger)pixels size:(CGSize)size{
    UIImage *colorImage = [UIImage imageWithColor:color size:size];
    GPUImageGaussianBlurFilter *filter = [[GPUImageGaussianBlurFilter alloc] init];
    filter.texelSpacingMultiplier = 5.0;
    filter.blurRadiusInPixels = pixels;
    [filter forceProcessingAtSize:colorImage.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:colorImage];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
//    GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
//    [blurFilter forceProcessingAtSize:size];
//    [blurFilter useNextFrameForImageCapture];
//    blurFilter.texelSpacingMultiplier = 5.0;
//    blurFilter.blurRadiusInPixels = pixels;
//    GPUImagePicture *strillImageSource = [[GPUImagePicture alloc] initWithImage:colorImage];
//    [strillImageSource addTarget:blurFilter];
//    
//    [strillImageSource processImage];
//    
//    return [blurFilter imageFromCurrentFramebuffer];
}

+ (UIImage *)image:(UIImage *)image blurRadiusInPixels:(NSInteger)pixels size:(CGSize)size{
    GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    [blurFilter forceProcessingAtSize:size];
    [blurFilter useNextFrameForImageCapture];
    blurFilter.texelSpacingMultiplier = 5.0;
    blurFilter.blurRadiusInPixels = pixels;
    GPUImagePicture *strillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    [strillImageSource addTarget:blurFilter];
    
    [strillImageSource processImage];
    
    return [blurFilter imageFromCurrentFramebuffer];
}

+ (UIImage*) imageToTransparent:(UIImage*) image
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00 || (*pCurPtr == 0x000000ff)|| (*pCurPtr == 255)) {
            
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 将内存转成image
    CGDataProviderRef dataProvider =CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight,8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast |kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true,kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}


/** 颜色变化 */

void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}



@end
