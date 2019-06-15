//
//  GoodStoreRecommendCell.m
//  jingGang
//
//  Created by 张康健 on 15/9/9.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "GoodStoreRecommendCell.h"
#import "RateView.h"
#import "GlobeObject.h"
#import "Masonry.h"
#import "Util.h"
#import "YSImageConfig.h"

@interface GoodStoreRecommendCell() {

}


@end

@implementation GoodStoreRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)layoutSubviews {
  [super layoutSubviews];
}

-(void)setRecommendStoreModel:(RecommendStoreModel *)recommendStoreModel {
    _recommendStoreModel = recommendStoreModel;
    NSString *twiceImgUrl = _recommendStoreModel.storeInfoPath;
    [YSImageConfig yy_view:self.storeImgView setImageWithURL:[NSURL URLWithString:twiceImgUrl] placeholderImage:DEFAULTIMG];
    self.storeNameLabel.text = _recommendStoreModel.storeName;
    self.rateView.scorePercent = _recommendStoreModel.evaluationAverage.floatValue;
    self.distanceLabel.text = [Util transferDistanceStrWithDistance:_recommendStoreModel.distance];
    self.addressLabel.text = _recommendStoreModel.storeAddress;
    
}


@end
