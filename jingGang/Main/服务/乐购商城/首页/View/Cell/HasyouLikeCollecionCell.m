//
//  HasyouLikeCollecionCell.m
//  jingGang
//
//  Created by 张康健 on 15/8/21.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "HasyouLikeCollecionCell.h"
#import "GlobeObject.h"

@interface HasyouLikeCollecionCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopSpace;

@end

@implementation HasyouLikeCollecionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.labelPrice.textColor = [YSThemeManager priceColor];
    
    // Initialization code
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;

    self.imageViewTopSpace.constant = 8.0;
    
}

@end
