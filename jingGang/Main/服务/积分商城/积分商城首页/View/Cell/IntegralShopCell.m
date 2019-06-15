//
//  IntegralShopCell.m
//  jingGang
//
//  Created by 张康健 on 15/10/30.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "IntegralShopCell.h"
#import "GlobeObject.h"
#import "IntegralListBO.h"
#import "JGIntegralCommendGoodsModel.h"
#import "YSImageConfig.h"

@interface IntegralShopCell ()
/**
 *  商品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewGoods;
/**
 *  商品标题
 */
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsTitle;
/**
 *  商品兑换所需积分
 */
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsIntegralPrice;

@end
@implementation IntegralShopCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
//    self.labelGoodsIntegralPrice.textColor = [YSThemeManager priceColor];
}

-(void)setModel:(JGIntegralCommendGoodsModel *)model {
    
    _model = model;
    
    self.labelGoodsTitle.text = model.igGoodsName;
    self.labelGoodsIntegralPrice.text = model.igGoodsIntegral;
    
    [YSImageConfig sd_view:self.imageViewGoods setimageWithURL:[NSURL URLWithString:model.igGoodsImg] placeholderImage:DEFAULTIMG];
}


@end
