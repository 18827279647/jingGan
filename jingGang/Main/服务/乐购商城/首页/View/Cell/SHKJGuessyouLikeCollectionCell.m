    //
//  KJGuessyouLikeCollectionCell.m
//  商品详情页collectionView测试
//
//  Created by 张康健 on 15/8/8.
//  Copyright (c) 2015年 com.organazation. All rights reserved.
//

#import "SHKJGuessyouLikeCollectionCell.h"
#import "GlobeObject.h"
#import "YSLoginManager.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"

@interface SHKJGuessyouLikeCollectionCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopSpace;

@end


@implementation SHKJGuessyouLikeCollectionCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.priceLabel.textColor = [YSThemeManager priceColor];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
//    [self assignData];

}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;

}

-(void)assignData {
    NSString *newStr = self.model.goodsMainPhotoPath;
    [YSImageConfig yy_view:self.goodsImgView setImageWithURL:[NSURL URLWithString:[YSThumbnailManager shopYouLikePicUrlString:newStr]] placeholderImage:DEFAULTIMG];
    self.goodsNameLabel.text = self.model.goodsName;
    CGFloat price = self.model.actualPrice;
    //判断有没手机专享价
    NSString *priceString = @"￥";
    if (self.model.hasMobilePrice.integerValue) {//有
        priceString = [NSString stringWithFormat:@"￥%.2f",price];
        
    }else{//没有手机专享价，可能有积分兑换价

        priceString =[NSString stringWithFormat:@"￥%.2f",price];
    }
    

    
    //是卷皮商品同时也是团购商品才要显示拼省图标
    if (self.model.isJuanpi.boolValue && self.model.isTuangou.boolValue) {
        self.juanPiGroupLabelWidth.constant = 24.0;
        self.juanPiGroupLabelWithPriceLabelSpace.constant = 5.0;
        priceString = [NSString stringWithFormat:@"¥%.2f",[self.model.tuanCprice floatValue]];
    }else{
        self.juanPiGroupLabelWidth.constant = 0.0;
        self.juanPiGroupLabelWithPriceLabelSpace.constant = 0.0;
    }
    
    NSMutableAttributedString *attrStrPrice = [[NSMutableAttributedString alloc]initWithString:priceString];
    
    [attrStrPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
    
    self.priceLabel.attributedText = attrStrPrice;

}


-(void)setModel:(GoodsDetailModel *)model {

    _model = model;
    [self assignData];
}


- (void)setGuessYouLikeData:(NSDictionary *)dict{
    NSString *newStr = dict[@"mainPhotoUrl"];
    //是否卷皮商品
    NSNumber *isJuanPi = (NSNumber *)dict[@"isJuanpi"];
    if (!isJuanPi.boolValue) {
        //不是卷皮商品才需要拼接缩略图尺寸
        newStr = [YSThumbnailManager shopYouLikePicUrlString:newStr];
    }
    
    
    [YSImageConfig yy_view:self.goodsImgView setImageWithURL:[NSURL URLWithString:newStr] placeholderImage:DEFAULTIMG];
    self.goodsNameLabel.text = dict[@"title"];
    
    //判断有没手机专享价
    NSString *priceString = @"￥";
    if ([dict[@"mobilePrice"] floatValue] == 0) {//有
        priceString = [NSString stringWithFormat:@"￥%.2f",[dict[@"storePrice"] floatValue]];
    }else{
        priceString = [NSString stringWithFormat:@"￥%.2f",[dict[@"mobilePrice"] floatValue]];
    }
    
    
    //团购价格
    NSNumber *tuanPrice = (NSNumber *)dict[@"tuanCprice"];
    
    //是否团购
    NSNumber *isTuangou = (NSNumber *)dict[@"isTuangou"];
    //是卷皮商品同时也是团购商品才要显示拼省图标
    if (isJuanPi.boolValue && isTuangou.boolValue) {
        self.juanPiGroupLabelWidth.constant = 24.0;
        self.juanPiGroupLabelWithPriceLabelSpace.constant = 5.0;
        priceString = [NSString stringWithFormat:@"￥%.2f",[tuanPrice floatValue]];
    }else{
        self.juanPiGroupLabelWidth.constant = 0.0;
        self.juanPiGroupLabelWithPriceLabelSpace.constant = 0.0;
    }
    
    NSMutableAttributedString *attrStrPrice = [[NSMutableAttributedString alloc]initWithString:priceString];
    
    [attrStrPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
    
    self.priceLabel.attributedText = attrStrPrice;
}


@end
