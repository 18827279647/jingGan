//
//  KJGuessyouLikeCollectionCell.h
//  商品详情页collectionView测试
//
//  Created by 张康健 on 15/8/8.
//  Copyright (c) 2015年 com.organazation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KJGuessyouLikeCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;

//拼省字样宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *JuanPiGroupLabelWidth;
//价格与拼省字样的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *juanPiGroupLabelWithPriceLabelSpace;

@end
