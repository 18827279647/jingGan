//
//  JGIntegralShopTableViewCell.m
//  jingGang
//
//  Created by HanZhongchou on 16/7/28.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGIntegralShopTableViewCell.h"
#import "JGIntegralCommendGoodsModel.h"
#import "GlobeObject.h"
#import "YSImageConfig.h"
#import "YSNearAdContentModel.h"
@interface JGIntegralShopTableViewCell ()


@end

@implementation JGIntegralShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.labelGoodsPrice.textColor = [YSThemeManager priceColor];
}

//- (void)setModel:(JGIntegralCommendGoodsModel *)model
//{
//    _model = model;
//    self.labelGoodsName.text = model.igGoodsName;
//    self.labelGoodsPrice.text = model.igGoodsIntegral;
//    [YSImageConfig sd_view:self.imageViewGoods setimageWithURL:[NSURL URLWithString:model.igGoodsImg] placeholderImage:DEFAULTIMG];
//}


- (void)setModel:(YSNearAdContent *)model
{
    _model = model;
    
   
    NSArray *array = [model.name componentsSeparatedByString:@"&"];
    NSLog(@"array:%@",array);
    NSString * string = [array objectAtIndex:0];
     NSString * string1 = [array objectAtIndex:1];
    NSString * string2 = [NSString stringWithFormat:@"%@ 积分",string1];
     self.labelGoodsName.text = string;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string2];
//    NSRange range1 = [[str string] rangeOfString:string1];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range1];
    NSRange range2 = [[str string] rangeOfString:@"积分"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:range2];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range2];
     NSLog(@"string:%@",string);
    self.labelGoodsPrice.attributedText = str;
//    self.labelGoodsPrice.text = model.igGoodsIntegral;
    [YSImageConfig sd_view:self.imageViewGoods setimageWithURL:[NSURL URLWithString:model.pic] placeholderImage:DEFAULTIMG];
}


@end
