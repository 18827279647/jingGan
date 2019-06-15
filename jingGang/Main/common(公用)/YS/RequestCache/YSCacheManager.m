//
//  YSCacheManager.m
//  jingGang
//
//  Created by dengxf on 16/9/21.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSCacheManager.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+YYWebImage.h"
#import "YYMemoryCache.h"
#import "YYDiskCache.h"
#import "SVProgressHUD.h"

@implementation YSCacheManager

+ (void)cacheSize:(void (^)(CGFloat))sizeCallback {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        SDWebImageManager *sdmgr = [SDWebImageManager sharedManager];
        NSUInteger sdSize = sdmgr.imageCache.getSize;
        YYImageCache *cache = [YYWebImageManager sharedManager].cache;
        NSUInteger yyMemorySize = 0;
        NSUInteger yyDiskSize = cache.diskCache.totalCost;
        CGFloat totleSize = (yyMemorySize + yyDiskSize + sdSize) / 1024.0 / 1024.0;
        if (!totleSize) {
            totleSize += .1;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            BLOCK_EXEC(sizeCallback,totleSize);
        });
    });
}

+ (void)clearCacheWithHudShowView:(UIView *)view completion:(voidCallback)completion{
    [UIWebView cleanCacheAndCookie];
    
    SDWebImageManager *sdmgr = [SDWebImageManager sharedManager];
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    // 1.取消下载
    [sdmgr cancelAll];
    
    // 2.清除内存中的所有图片
    [sdmgr.imageCache clearMemory];
    [sdmgr.imageCache clearDisk];
    [cache.memoryCache removeAllObjects];
    [cache.diskCache removeAllObjects];
    [cache.diskCache removeAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
        JGLog(@"removedCount:%d,totalCount：%d",removedCount,totalCount);
    } endBlock:^(BOOL error) {
        
    }];
    
    if (!view) {
        return;
    }
    
    [SVProgressHUD showInView:view status:@"清除中..."];
    @weakify(view);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(view);
        [SVProgressHUD showInView:view status:@"清除完成"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            BLOCK_EXEC(completion);
        });
    });
}

@end
