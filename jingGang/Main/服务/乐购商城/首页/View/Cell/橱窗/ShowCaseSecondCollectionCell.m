//
//  ShowCaseSecondCollectionCell.m
//  橱窗collectionView测试
//
//  Created by 张康健 on 15/8/13.
//  Copyright (c) 2015年 com.organazation. All rights reserved.
//

#import "ShowCaseSecondCollectionCell.h"
#import "GlobeObject.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"

@interface ShowCaseSecondCollectionCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *originPriceLabelSpecaBottom;

@end

@implementation ShowCaseSecondCollectionCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.priceLabel.textColor = [YSThemeManager priceColor];
    NSString *strOriginallyPrice = [NSString stringWithFormat:@"¥%.0f",0.00];
    NSMutableAttributedString *attrStrOriginallyPrice = [[NSMutableAttributedString alloc]initWithString:strOriginallyPrice];
    //添加删除线
    [attrStrOriginallyPrice addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSBaselineOffsetAttributeName:@(0)} range:NSMakeRange(0, strOriginallyPrice.length)];
    self.originPriceLab.attributedText = attrStrOriginallyPrice;
    self.originPriceLab.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
    
//    if (iPhone5) {
//        self.originPriceLabelSpecaBottom.constant = -5;
//    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
}


-(void)setModel:(GoodsDetailModel *)model {
    
    _model = model;
    NSString *newStr = _model.goodsMainPhotoPath;

    NSString *strOriginallyPrice = [NSString stringWithFormat:@"¥%.0f",[model.goodsPrice floatValue]];
    NSMutableAttributedString *attrStrOriginallyPrice = [[NSMutableAttributedString alloc]initWithString:strOriginallyPrice];
    //添加删除线
    [attrStrOriginallyPrice addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSBaselineOffsetAttributeName:@(0)} range:NSMakeRange(0, strOriginallyPrice.length)];
    self.originPriceLab.attributedText = attrStrOriginallyPrice;
    self.originPriceLab.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
//    self.originPriceLab.text = [NSString stringWithFormat:@"¥%.2f",[model.goodsPrice floatValue]];
    
    [YSImageConfig yy_view:self.showCaseImgView setImageWithURL:[NSURL URLWithString:[YSThumbnailManager shopSpecialPricePicUrlString:newStr]] placeholderImage:DEFAULTIMG];
    
    CGFloat price = _model.actualPrice;
    
    //判断有没手机专享价
    if (iPhone5 || iPhone6) {
        if (price >= 100) {
            self.priceLabel.text =[NSString stringWithFormat:@"￥%.0f",price];
        }else {
            self.priceLabel.text =[NSString stringWithFormat:@"￥%.2f",price];
        }
    }else {
        self.priceLabel.text =[NSString stringWithFormat:@"￥%.2f",price];
    }
    
}

@end
