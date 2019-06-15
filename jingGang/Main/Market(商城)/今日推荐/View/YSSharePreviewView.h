//
//  YSSharePreviewView.h
//  jingGang
//
//  Created by Eric Wu on 2019/6/5.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "GoodsDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSSharePreviewView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *commodityImage;
@property (weak, nonatomic) IBOutlet UIImageView *qrIMage;

@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCoupon;
@property (strong, nonatomic) GoodsDetailsModel *model;
+ (instancetype)sharePreviewView;
@end

NS_ASSUME_NONNULL_END
