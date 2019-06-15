//
//  IntegralHomeCollectionView.h
//  jingGang
//
//  Created by 张康健 on 15/11/22.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IntegralHomeHeaderView;

@interface IntegralHomeCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)NSMutableArray *dataArr;

@property (nonatomic, strong)IntegralHomeHeaderView *headerView;

-(void)setCollectionlayout;

@end
