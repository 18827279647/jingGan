//
//  YSNearAdContentModel.m
//  jingGang
//
//  Created by dengxf on 17/7/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSNearAdContentModel.h"

NSString * const YSAdvertOriginalTypeAIO = @"yitiji";
NSString * const YSAdvertOriginalTypeJfdh = @"jifenduihuan";
NSString *const YSAdvertOriginalTypeCYDoctor = @"chunyuyisheng";
NSString *const YSyuyueguahaoDoctor = @"yuyueguahao";
NSString *const jinxuan = @"jinxuan";
@implementation YSNearAdContent


@end

@implementation YSNearAdContentModel

- (CGFloat)singleAdContentHeight {
    if (self.adWidth == 0) {
        return 0.f;
    }
    CGFloat totleHeight = 0.f;
    if (self.nameShow) {
        totleHeight += 42.;
    }
    CGFloat h = (ScreenWidth * self.adHeight) / self.adWidth;
    return (totleHeight + h);
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
                @"adContent" : [YSNearAdContent class]
             };
}

@end
