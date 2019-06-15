//
//  YSNearServiceClassCollectionView.h
//  jingGang
//
//  Created by HanZhongchou on 2017/11/7.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSNearServiceClassModel;
@interface YSNearServiceClassCollectionView : UICollectionView
//分类数据数组
@property (nonatomic,strong)NSMutableArray *arrayClassfyData;
@property (nonatomic,copy) void (^collectionCellDidSelectBlock)(YSNearServiceClassModel *selectModel);

@end

