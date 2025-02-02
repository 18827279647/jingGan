//
//  ShowCaseSecondCollectionCell.h
//  橱窗collectionView测试
//
//  Created by 张康健 on 15/8/13.
//  Copyright (c) 2015年 com.organazation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"

@interface ShowCaseSecondCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *showCaseImgView;



//价格背景view
@property (weak, nonatomic) IBOutlet UIView *priceBgView;

//价格label
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@property (nonatomic,strong)GoodsDetailModel *model;
@property (weak, nonatomic) IBOutlet UILabel *originPriceLab;

@end
