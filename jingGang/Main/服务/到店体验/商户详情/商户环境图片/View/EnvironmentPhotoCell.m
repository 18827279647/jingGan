//
//  EnvironmentPhotoCell.m
//  jingGang
//
//  Created by 鹏 朱 on 15/9/10.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "EnvironmentPhotoCell.h"
#import "urlManagerHeader.h"

@implementation EnvironmentPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
        CGFloat width = frame.size.width - 2;
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, width, 98)];
        img.image = IMAGE(@"ask_back_pic.jpg");
        img.contentMode =  UIViewContentModeScaleAspectFill;
        img.userInteractionEnabled = YES;
        [self.contentView addSubview:img];
        self.environmentImg = img;
    }
    return self;
}

@end
