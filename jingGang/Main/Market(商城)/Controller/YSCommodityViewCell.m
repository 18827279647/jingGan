//
//  YSCommodityViewCell.m
//  jingGang
//
//  Created by Eric Wu on 2019/6/2.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSCommodityViewCell.h"

@interface YSCommodityViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@end
@implementation YSCommodityViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGFloat width = (kScreenWidth - (3 * 9)) / 2;
    CGSize itemSize = CGSizeMake(width, width);
   
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.size.mas_equalTo(itemSize);
    }];
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(9);
        make.right.offset(-9);
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
        make.height.mas_greaterThanOrEqualTo(10);
    }];
    [self.lblPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.lblTitle);
        make.height.mas_greaterThanOrEqualTo(10);
        make.bottom.offset(-10);
    }];
}

- (void)setModel:(GoodListModel *)model
{
    _model = model;
    [self.imageView sd_setImageWithURL:CRURL(model.goodsMainPhotoPath)];
    self.lblTitle.text = model.goodsName;
    
    NSMutableAttributedString *priceAttr = [[NSMutableAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName: kPingFang_Regular(10), NSForegroundColorAttributeName: UIColorHex(E31436)}];
    CGFloat goodsCurrentPrice = [model.goodsCurrentPrice floatValue];
    CGFloat storePrice = [model.storePrice floatValue];

    [priceAttr appendAttributedString:[[NSAttributedString alloc] initWithString:CRString(@"%.2f ", goodsCurrentPrice) attributes:@{NSFontAttributeName: kPingFang_Regular(14), NSForegroundColorAttributeName: UIColorHex(E31436)}]];
    
    NSMutableAttributedString *storePriceAttr = [[NSMutableAttributedString alloc] initWithString:CRString(@"¥%.2f ", storePrice) attributes:@{NSForegroundColorAttributeName: UIColorHex(888888), NSFontAttributeName: kPingFang_Regular(10)}];
    [storePriceAttr setStrikethroughColor:UIColorHex(888888)];
    [storePriceAttr setStrikethroughStyle:NSUnderlineStyleSingle];
    [priceAttr appendAttributedString:storePriceAttr];
    self.lblPrice.attributedText = priceAttr;
    
}
@end
