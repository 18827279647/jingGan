//
//  IntegralDetailTableViewCell.m
//  jingGang
//
//  Created by ray on 15/10/30.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "IntegralDetailTableViewCell.h"
#import "IGo.h"
#import "GlobeObject.h"
#import "YSImageConfig.h"

@interface IntegralDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *costIntegral;
@property (weak, nonatomic) IBOutlet UILabel *coutLabel;

@end

@implementation IntegralDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.costIntegral.textColor = [YSThemeManager buttonBgColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEntity:(id)object {
    IGo *goodsInfo = object;
//    CGRect imageFrame = self.goodsImage.frame;
    [YSImageConfig sd_view:self.goodsImage setimageWithURL:[NSURL URLWithString:goodsInfo.images] placeholderImage:DEFAULTIMG];
    self.goodsName.text = goodsInfo.igoName;
    self.costIntegral.text = goodsInfo.igoInteral.stringValue;
    self.coutLabel.text = [@"x" stringByAppendingString:goodsInfo.count.stringValue];
}

@end
