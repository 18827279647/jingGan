//
//  NearestCell.m
//  jingGang
//
//  Created by 张康健 on 15/9/9.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "NearestCell.h"
#import "GlobeObject.h"
#import "YSImageConfig.h"

@implementation NearestCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
   
    NSString *twiceImgUrl = self.awareStoreModel.goodsPath;
    
    [YSImageConfig yy_view:self.serviceImgView setImageWithURL:[NSURL URLWithString:twiceImgUrl] placeholderImage:DEFAULTIMG];
    self.serviceNameLabel.text = self.awareStoreModel.goodsName;
    self.storeNameLabel.text = self.awareStoreModel.storeName;
//   self.servicePriceLabel.text = [NSString stringWithFormat:@"%@",self.awareStoreModel.price];
    self.servicePriceLabel.text = kNumberToStrRemain2Point(self.awareStoreModel.price);
    self.saledNumBerLabel.text = [NSString stringWithFormat:@"【已售%@】",self.awareStoreModel.sales];
    self.distanceLabel.text =[Util transferDistanceStrWithDistance:self.awareStoreModel.distance];
}



@end
