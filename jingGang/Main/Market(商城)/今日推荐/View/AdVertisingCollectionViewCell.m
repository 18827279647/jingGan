//
//  AdVertisingCollectionViewCell.m
//  jingGang
//
//  Created by whlx on 2019/5/23.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "AdVertisingCollectionViewCell.h"

@interface AdVertisingCollectionViewCell ()

@end

@implementation AdVertisingCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.AdVertisingImageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:self.AdVertisingImageView];
        
    }
    return self;
}


@end
