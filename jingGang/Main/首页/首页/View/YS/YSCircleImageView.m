//
//  YSCircleImageView.m
//  jingGang
//
//  Created by dengxf on 17/3/31.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSCircleImageView.h"

@implementation YSCircleImageView


- (void)setOriginImage:(UIImage *)originImage {
    _originImage = originImage;
    self.image = originImage;
}

- (void)setCropImage:(UIImage *)cropImage {
    _cropImage = cropImage;
    self.image = cropImage;
}


@end
