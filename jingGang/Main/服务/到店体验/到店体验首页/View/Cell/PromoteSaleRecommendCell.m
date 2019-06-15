//
//  PromoteSaleRecommendCell.m
//  jingGang
//
//  Created by 张康健 on 15/9/9.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "PromoteSaleRecommendCell.h"
#import "GlobeObject.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
@implementation PromoteSaleRecommendCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setServiceModel:(ServiceModel *)serviceModel {

    _serviceModel = serviceModel;
     NSString *twiceImgUrl = _serviceModel.groupAccPath;
    [YSImageConfig yy_view:self.serviceImgView setImageWithURL:[NSURL URLWithString:[YSThumbnailManager nearbyPromoteSaleRecommendPicUrlString:twiceImgUrl]] placeholderImage:DEFAULTIMG];
    self.serviceNameLabel.text = _serviceModel.ggName;
    self.storeLabel.text = _serviceModel.storeName;
    
    self.servicePriceLabel.text = kNumberToStrRemain2Point(self.serviceModel.groupPrice);
    self.servicePriceLabel.textColor = [YSThemeManager priceColor];
    self.RMB.textColor = [YSThemeManager priceColor];
    self.distanceLabel.text =  [Util transferDistanceStrWithDistance:self.serviceModel.distance];
    self.hasSaledLabel.text = [NSString stringWithFormat:@"已售%@",_serviceModel.selledCount];
    
    
    NSAttributedString *attrStrOriginallyPrice = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%.2f",[serviceModel.costPrice floatValue]] attributes:
                                                  
                                                  @{NSFontAttributeName:[UIFont systemFontOfSize:12.f],
                                                    
                                                    NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#9b9b9b"],
                                                    
                                                    NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                    
                                                    NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#9b9b9b"]}];
    
    self.labelCustomaryPrice.attributedText = attrStrOriginallyPrice;
}


@end
