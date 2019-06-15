//
//  WSJMerchantDetailsTableViewCell.m
//  jingGang
//
//  Created by thinker on 15/9/9.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "WSJMerchantDetailsTableViewCell.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
#import "GlobeObject.h"
@interface WSJMerchantDetailsTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xianHeight;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *selledCount;
@property (weak, nonatomic) IBOutlet UILabel *labelOriginallyPrice;

@end

@implementation WSJMerchantDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.xianHeight.constant = 0.25;
    self.priceLabel.textColor = [YSThemeManager priceColor];
}

-(void)willCustomCellWithData:(NSDictionary *)dict
{
    [YSImageConfig yy_view:self.titleImageVIew setImageWithURL:[NSURL URLWithString:[YSThumbnailManager nearbyMerchantDetailCouponPicUrlString:dict[@"groupAccPath"]]] placeholderImage:DEFAULTIMG];
    self.titleNameLabel.text = dict[@"ggName"];
    
    NSMutableAttributedString *priceAttributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f",[dict[@"groupPrice"] floatValue]]];
    [priceAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, 1)];
    
    self.priceLabel.attributedText = priceAttributedString;
    
    self.selledCount.text = [NSString stringWithFormat:@"【已售%@】",dict[@"selledCount"]];
//    costPrice
    
    NSString *strOriginallyPrice = [NSString stringWithFormat:@"￥%.2f",[dict[@"costPrice"] floatValue]];
    
    NSMutableAttributedString *attrStrOriginallyPrice = [[NSMutableAttributedString alloc]initWithString:strOriginallyPrice];
    //添加删除线
    [attrStrOriginallyPrice addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSBaselineOffsetAttributeName:@(0)} range:NSMakeRange(0, strOriginallyPrice.length)];
    
    self.labelOriginallyPrice.attributedText = attrStrOriginallyPrice;

}

@end
