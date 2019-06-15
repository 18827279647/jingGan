//
//  ShoppingCircleCellectionCell.m
//  商品详情页collectionView测试
//
//  Created by 张康健 on 15/8/13.
//  Copyright (c) 2015年 com.organazation. All rights reserved.
//

#import "ShoppingCircleCellectionCell.h"
#import "YSImageConfig.h"
@implementation ShoppingCircleCellectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(ShoppingCircleModel *)model
{
    _circleTitleLabel.text = model.title;
    
    NSString *regex = @"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([urlTest evaluateWithObject:model.image]) {
        [YSImageConfig yy_view:_shopCircleImgView setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
        
        
    }else{
        _shopCircleImgView.image = [UIImage imageNamed:model.image];
    }
    
}
@end

@implementation ShoppingCircleModel
@end
