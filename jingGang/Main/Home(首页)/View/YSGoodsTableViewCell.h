//
//  YSGoodsTableViewCell.h
//  jingGang
//
//  Created by 左衡 on 2018/7/29.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"
@interface YSGoodsTableViewCell : UITableViewCell
@property (nonatomic, strong)NSArray <GoodsDetailModel *> *models;
@property (nonatomic, strong)id <UICollectionViewDelegate>delegate;
@end


@interface GoodCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)GoodsDetailModel *model;
@end
