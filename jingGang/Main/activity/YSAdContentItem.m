//
//  YSAdContentItem.m
//  jingGang
//
//  Created by dengxf on 2017/11/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSAdContentItem.h"
#import "YSNearAdContentModel.h"

@implementation YSAdContentItem

- (CGFloat)adTotleHeight {
    CGFloat height = 0.;
    if (!self.adContentBO.count) {
        return height;
    }

    NSInteger singleH = 0.f;
    for (YSNearAdContentModel *singleAdContentModel in self.adContentBO) {
        singleH += singleAdContentModel.singleAdContentHeight;
      
    }
    singleH += (self.adContentBO.count - 1) * 6.;
    
    return singleH;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"adContentBO" : [YSNearAdContentModel class]
             };
}

@end
