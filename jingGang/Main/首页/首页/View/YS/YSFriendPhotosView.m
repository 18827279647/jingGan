//
//  YSFriendPhotosView.m
//  jingGang
//
//  Created by dengxf on 16/7/23.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSFriendPhotosView.h"
#import "GlobeObject.h"
#import "UIImageView+CornerRadius.h"
#import "UIImage+YYAdd.h"
#import "YSThumbnailManager.h"
#import "YSImageConfig.h"

@implementation YSFriendPhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

//CGRect YYCGRectFitWithContentMode(CGRect rect, CGSize size, UIViewContentMode mode) {
//    return rect;
//}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
//    while (self.subviews.count) {
//        [self.subviews.lastObject removeFromSuperview];
//    }
//
    NSUInteger photosCount = photos.count;
    YSHealthyCircleThumbnailLayoutType layoutType;
    if (photosCount == 1) {
        /**
         *  一行只有一张图片 */
        layoutType = YSHealthyCircleThumbnailLayoutOnlyOneType;
    }else if (photosCount == 2 || photosCount == 4) {
        /**
         *  一行最多两张图片 */
        layoutType = YSHealthyCircleThumbnailLayoutTwoColType;
    }else {
        /**
         *  一行最多有三张图片 */
        layoutType = YSHealthyCircleThumbnailLayoutThreeColType;
    }
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.subviews.count < photosCount) {
        NSInteger index = self.subviews.count;
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.backgroundColor = JGClearColor;
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.userInteractionEnabled = YES;
        photoView.layer.cornerRadius = 3.0;
        photoView.clipsToBounds = YES;
        @weakify(self);
        [photoView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            @strongify(self);
            BLOCK_EXEC(self.clickImgPage,index);
        }];
        [self addSubview:photoView];
    }
    
    UIImage *placeholderImage = [UIImage imageNamed:@"ys_placeholder_circle"];
    
    for (NSInteger i = 0; i < self.subviews.count; i ++) {
        UIImageView *photoView = [self.subviews xf_safeObjectAtIndex:i];
        // 性能优化处理， 否则cell复用，只能removeSubViewFromSurpurView，然后创建View 影响性能
        if (i < photos.count) {
            photoView.hidden = NO;
            NSString *picUrl = [YSThumbnailManager healthyCircleThumbnailPicUrlString:[photos xf_safeObjectAtIndex:i] picLayoutType:layoutType];
            if (layoutType == YSHealthyCircleThumbnailLayoutOnlyOneType) {
                placeholderImage = [UIImage imageNamed:@"ys_placeholder_circle_ rectangle"];
            }
//            [photoView setImageWithURL:[NSURL URLWithString:picUrl]
//                           placeholder:placeholderImage
//                               options:YYWebImageOptionSetImageWithFadeAnimation
//                            completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//                                
//                            }];
            [YSImageConfig yy_view:photoView setImageWithURL:[NSURL URLWithString:picUrl] placeholder:placeholderImage options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                
            }];
        }else {
            photoView.hidden = YES;
        }
    }
    UIButton *bu;
    [bu addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        
    }];
    
}

#define HWStatusPhotoWH 72
#define HWStatusPhotoMargin 10
#define HWStatusPhotoMaxCol(count) ((count==4)?2:3)
- (void)layoutSubviews
{
    [super layoutSubviews];
        
    // 设置图片的尺寸和位置
    NSUInteger photosCount = self.photos.count;
    
    /**
     *  一行最多图片个数 */
    CGFloat photosW;
    CGFloat photosH;
    CGFloat marginX = 12.0f;
    CGFloat photoMargin = 6.0f;
    CGFloat whRate = 0.6571f;
    
    NSInteger picSizeType = 0;
    
    if (photosCount == 1) {
        /**
         *  一行只有一张图片 */
        photosW = (ScreenWidth - 2 * marginX) *whRate ;
        photosH = photosW;
        CGFloat widthHeightRate = 350.0 / 230.;
        photosH = photosW / widthHeightRate;
        picSizeType = 1;
    }else if (photosCount == 2 || photosCount == 4) {
        /**
         *  一行最多两张图片 */
        photosW = (ScreenWidth - marginX * 2 - photoMargin) / 2;
        photosH = photosW;
        picSizeType = 2;
    }else {
        /**
         *  一行最多有三张图片 */
        photosW = (ScreenWidth - marginX * 2- photoMargin * 2) / 3;
        photosH = photosW;
        picSizeType = 3;
    }

    
    for (int i = 0; i<photosCount; i++) {
        UIImageView *photoView = self.subviews[i];
        int col;
        if (photosCount == 1) {
            
            photoView.x = marginX;
            
        }else if (photosCount == 2 || photosCount == 4) {
        
            col = i % 2;
            photoView.x = marginX + (photosW * 0.75 + photoMargin) * col;
        }else {
            
            col = i % 3;
            photoView.x = marginX + (photosW + photoMargin) *col;
        }
        
        int row;
        if (photosCount == 1) {
            photoView.y = 0;
        }else if (photosCount == 2 || photosCount == 4) {
            row = i / 2;
            photoView.y = row * (photosH * 0.75 + photoMargin);
        }else {
            row = i / 3;
            photoView.y = row * (photosH + photoMargin);
        }
        photoView.width = photosW;
        photoView.height = photosH;
        if (picSizeType == 2) {
            photoView.width = photosW * 0.75;
            photoView.height = photosH * 0.75;
        }
    }
}

+ (CGSize)sizeWithCount:(NSUInteger)count
{
    NSInteger photosCount = count;
    
    /**
     *  一行最多图片个数 */
    CGFloat photosW;
    CGFloat photosH;
    CGFloat marginX = 12.0f;
    CGFloat photoMargin = 6.0f;
    CGFloat whRate = 0.6571f;
    
    NSInteger row;
    if (photosCount == 1) {
        /**
         *  一行只有一张图片 */
        photosW = (ScreenWidth - 2 * marginX) * whRate;
        photosH = photosW;
        CGFloat widthHeightRate = 350.0 / 230.;
        photosH = photosW / widthHeightRate;
        return (CGSize){ScreenWidth,photosH};
        
    }else if (photosCount == 2 || photosCount == 4) {
        /**
         *  一行最多两张图片 */
        photosW = (ScreenWidth - marginX * 2 - photoMargin) / 2;
        photosH = photosW;
        row = photosCount / 2;
        return (CGSize){ScreenWidth,(row * photosH + photoMargin * (row - 1)) * 0.75};
    }else {
        /**
         *  一行最多有三张图片 */
        photosW = (ScreenWidth - marginX * 2- photoMargin * 2) / 3;
        photosH = photosW;
        if (photosCount % 3 == 0) {
            row = photosCount /3;
        }else {
            row = (photosCount/3) + 1;

        }
        return (CGSize){ScreenWidth,row * photosH + photoMargin * (row - 1)};
    }
}


@end
