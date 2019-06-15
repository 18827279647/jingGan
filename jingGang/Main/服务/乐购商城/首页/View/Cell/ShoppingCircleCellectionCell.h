//
//  ShoppingCircleCellectionCell.h
//  商品详情页collectionView测试
//
//  Created by 张康健 on 15/8/13.
//  Copyright (c) 2015年 com.organazation. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShoppingCircleModel;
@interface ShoppingCircleCellectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *circleButton;
@property (weak, nonatomic) IBOutlet UILabel *circleTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shopCircleImgView;

@property (nonatomic, strong) ShoppingCircleModel *model;
@end

@interface ShoppingCircleModel: NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *image;
@end
