//
//  YSCacheManager.h
//  jingGang
//
//  Created by dengxf on 16/9/21.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSCacheManager : NSObject

+ (void)cacheSize:(void(^)(CGFloat totleSize))sizeCallback;

+ (void)clearCacheWithHudShowView:(UIView *)view completion:(voidCallback)completion;

@end
