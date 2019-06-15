//
//  JGPersonalAwayStoreCell.m
//  jingGang
//
//  Created by HanZhongchou on 16/7/28.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGPersonalAwayStoreCell.h"
#import "JGPersonalAwayStoreModel.h"
#import "GlobeObject.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"

@interface JGPersonalAwayStoreCell ()
/**
 *  销售数量
 */
@property (weak, nonatomic) IBOutlet UILabel *labelSellCount;
/**
 *  距离
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonDistance;
/**
 *  商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsName;
/**
 *  商店名称
 */
@property (weak, nonatomic) IBOutlet UILabel *labelStoreName;
/**
 *  价格
 */
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
/**
 *  商品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewGoods;
/**
 *  原价
 */
@property (weak, nonatomic) IBOutlet UILabel *labelOriginallyPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressWithRightSpace;

@end


@implementation JGPersonalAwayStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.labelPrice.textColor = kGetColor(101,187,177);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(JGPersonalAwayStoreModel *)model
{
    _model = model;
    
    NSMutableAttributedString *priceAttributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%.2f",model.price]];
    [priceAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, 1)];
    self.labelPrice.attributedText = priceAttributedString;
    
    self.labelGoodsName.text= model.goodsName;
    self.labelSellCount.text = [NSString stringWithFormat:@"已售%@",model.sales];
    self.labelStoreName.text = model.storeName;
    
    CGFloat distanceFloat = [model.distance floatValue];
    
    if (distanceFloat < 1000) {
        [self.buttonDistance setTitle:[NSString stringWithFormat:@"%.0fm",distanceFloat] forState:UIControlStateNormal];
    }else{
        
        [self.buttonDistance setTitle:[NSString stringWithFormat:@"%.2fkm",distanceFloat/1000] forState:UIControlStateNormal];
    }
    
    [YSImageConfig sd_view:self.imageViewGoods setimageWithURL:[NSURL URLWithString:[YSThumbnailManager nearbyDistanceLessPicUrlString:model.goodsPath]] placeholderImage:DEFAULTIMG];
    
    
    NSAttributedString *attrStrOriginallyPrici = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%.2f",model.costPrice] attributes:
 
                                   @{NSFontAttributeName:[UIFont systemFontOfSize:12.f],
    
                                     NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#9b9b9b"],
    
                                     NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
   
                                     NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#9b9b9b"]}];
    self.labelOriginallyPrice.attributedText = attrStrOriginallyPrici;
    
    
    CGSize size = [[self.buttonDistance currentTitle] sizeWithFont:[UIFont systemFontOfSize:12] maxH:14.5];
    CGFloat space = 15.0;

    self.addressWithRightSpace.constant = size.width + 12 +space;
}

@end
