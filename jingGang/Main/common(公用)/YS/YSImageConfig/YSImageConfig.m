//
//  YSImageConfig.m
//  jingGang
//
//  Created by dengxf11 on 17/5/5.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSImageConfig.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+YYWebImage.h"
#import "UIButton+YYWebImage.h"

@implementation YSImageConfig

#pragma mark ---UIImageView+YYWebViewImage
+ (void)yy_view:(UIView *)view
setImageWithURL:(NSURL *)url
placeholderImage:(UIImage *)placeholderImage
{
    [self yy_view:view
  setImageWithURL:url
      placeholder:placeholderImage
          options:kNilOptions
         progress:nil
        transform:nil
       completion:nil];
}


+ (void)yy_view:(UIView *)view
setImageWithURL:(NSURL *)imageURL
    placeholder:(UIImage *)placeholder
        options:(YYWebImageOptions)options
     completion:(YYWebImageCompletionBlock)completion
{
    [self yy_view:view
  setImageWithURL:imageURL
      placeholder:placeholder
          options:options
         progress:nil
        transform:nil
       completion:completion];
}

+(void)yy_view:(UIView *)view
setImageWithURL:(NSURL *)imageURL
placeholder:(UIImage *)placeholder
options:(YYWebImageOptions)options
progress:(YYWebImageProgressBlock)progress
transform:(YYWebImageTransformBlock)transform
completion:(YYWebImageCompletionBlock)completion
{
    if (!view) {
        return;
    }
    if ([view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)view;
        [imageView setImageWithURL:imageURL placeholder:placeholder options:options progress:progress transform:transform completion:completion];
    }else {
        
    }
}

+ (void)yy_button:(UIButton *)button setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)image completed:(void (^)(UIImage *))completed
{
    if (!button) {
        return;
    }
    [button setImageWithURL:imageURL forState:UIControlStateNormal placeholder:image options:YYWebImageOptionProgressive completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (!error) {
            BLOCK_EXEC(completed,image);
        }
    }];
}

+ (void)yy_requestImageWithURL:(NSURL *)url options:(YYWebImageOptions)options progress:(YYWebImageProgressBlock)progress transform:(YYWebImageTransformBlock)transform completion:(YYWebImageCompletionBlock)completion
{
    [[YYWebImageManager sharedManager] requestImageWithURL:url options:options progress:progress transform:transform completion:completion];
}

#pragma mark ---UIImageView+SDWebViewImage
+ (void)sd_view:(UIView *)view setimageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage
{
    [self sd_view:view
  setImageWithURL:url
 placeholderImage:placeholderImage
          options:0
         progress:nil
        completed:nil];
}

+ (void)sd_view:(UIView *)view
setImageWithURL:(NSURL *)url
placeholderImage:(UIImage *)placeholder
        options:(SDWebImageOptions)options
{
    [self sd_view:view
  setImageWithURL:url
 placeholderImage:placeholder
          options:options
         progress:nil
        completed:nil];
}


+ (void)sd_view:(UIView *)view setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock
{
    if (!view) {
        return;
    }
    if ([view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)view;
        [imageView sd_setImageWithURL:url
                     placeholderImage:placeholder
                              options:options
                             progress:progressBlock
                            completed:completedBlock];
    }else {
        
    }
}

+ (void)sd_downloadImageWithURL:(NSURL *)url options:(SDWebImageDownloaderOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageDownloaderCompletedBlock)completedBlock
{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:options progress:progressBlock completed:completedBlock];
}

+ (void)ajustFrameWithLoadRemoteImageUrl:(NSString *)url
                                 options:(YYWebImageOptions)options
                                  result:(void(^)(BOOL ret,UIImage *iamge,CGSize size))result
{
    [self yy_requestImageWithURL:[NSURL URLWithString:url] options:options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        return image;
    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (image) {
            BLOCK_EXEC(result,YES,image,image.size);
        }else {
            BLOCK_EXEC(result,NO,nil,CGSizeZero);
        }
    }];
}
@end
