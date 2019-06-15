//
//  YSImageConfig.h
//  jingGang
//
//  Created by dengxf11 on 17/5/5.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"
#import "YYWebImageManager.h"

@interface YSImageConfig : NSObject

#pragma mark -- UIImageView+YYWebViewImage
+ (void)yy_view:(UIView *)view
setImageWithURL:(NSURL *)url
placeholderImage:(UIImage *)placeholderImage;

+ (void)yy_view:(UIView *)view
setImageWithURL:(NSURL *)imageURL
    placeholder:(UIImage *)placeholder
        options:(YYWebImageOptions)options
     completion:(YYWebImageCompletionBlock)completion;

+ (void)yy_view:(UIView *)view
setImageWithURL:(NSURL *)imageURL
    placeholder:(UIImage *)placeholder
        options:(YYWebImageOptions)options
       progress:(YYWebImageProgressBlock)progress
      transform:(YYWebImageTransformBlock)transform
     completion:(YYWebImageCompletionBlock)completion;

+ (void)yy_button:(UIButton *)button setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)image completed:(void(^)(UIImage *image))completed;

+ (void)yy_requestImageWithURL:(NSURL *)url
                       options:(YYWebImageOptions)options
                      progress:(YYWebImageProgressBlock)progress
                     transform:(YYWebImageTransformBlock)transform
                    completion:(YYWebImageCompletionBlock)completion;

#pragma mark -- UIImageView+SDWebViewImage
+ (void)sd_view:(UIView *)view
setimageWithURL:(NSURL *)url
placeholderImage:(UIImage *)placeholderImage;

+ (void)sd_view:(UIView *)view
setImageWithURL:(NSURL *)url
placeholderImage:(UIImage *)placeholder
        options:(SDWebImageOptions)options;

+ (void)sd_view:(UIView *)view
setImageWithURL:(NSURL *)url
placeholderImage:(UIImage *)placeholder
        options:(SDWebImageOptions)options
       progress:(SDWebImageDownloaderProgressBlock)progressBlock
      completed:(SDWebImageCompletionBlock)completedBlock;

+ (void)sd_downloadImageWithURL:(NSURL *)url
                        options:(SDWebImageDownloaderOptions)options
                       progress:(SDWebImageDownloaderProgressBlock)progressBlock
                      completed:(SDWebImageDownloaderCompletedBlock)completedBlock;

#pragma mark extension
+ (void)ajustFrameWithLoadRemoteImageUrl:(NSString *)url
                                 options:(YYWebImageOptions)options
                                  result:(void(^)(BOOL ret,UIImage *iamge,CGSize size))result;
@end
