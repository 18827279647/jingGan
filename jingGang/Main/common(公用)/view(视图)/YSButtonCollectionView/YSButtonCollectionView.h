//
//  YSButtonCollectionView.h
//  jingGang
//
//  Created by 左衡 on 2018/7/28.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShoppingCircleModel;
@interface YSButtonCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)NSArray <ShoppingCircleModel *>*itemModels;
@end
