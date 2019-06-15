//
//  KJDarlingCommentCell.h
//  jingGang
//
//  Created by 张康健 on 15/8/17.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define cellOriginalHeight 559
#import "DarlingCommentModel.h"
#import "GoodsInfoModel.h"
@class XFStarRateView;

@class RateView;
@interface KJDarlingCommentCell : UITableViewCell
//三个评级view
@property (nonatomic, strong)XFStarRateView *descRateView;
@property (nonatomic, strong)XFStarRateView *serviceRateView;
@property (nonatomic, strong)XFStarRateView *deleverRateView;

@property (nonatomic, strong)GoodsInfoModel *goodsInfoModel;
@property (nonatomic, strong)DarlingCommentModel *model;
@property (weak, nonatomic) IBOutlet UITextView *commentContentTextView;


@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;

//解决复用问题
//@property BOOL isAddedHeight;

@end
