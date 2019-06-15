//
//  HappyShoppingNewView.h
//  jingGang
//
//  Created by 张康健 on 15/11/21.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "happyShoppingCollectionView.h"
@interface HappyShoppingNewView : UIView
@property (weak, nonatomic) IBOutlet HappyShoppingCollectionView *happyShoppingCollectionView;
- (void)scrollTop;

//收到通知后让商城首页自动下拉刷新
- (void)collectionViewHeaderBeginRefreshing;
@end
