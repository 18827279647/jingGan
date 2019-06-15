//
//  YSGoodsOneStairCollectionView.h
//  jingGang
//
//  Created by HanZhongchou on 2017/6/5.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSGoodsOneStairCollectionView : UICollectionView
//商品分类数据数组
@property (nonatomic,strong)NSMutableArray *arrayClassfyData;
//点击了哪个一级类目
@property (nonatomic,copy)  void (^didSelectOneClassfyCollectionCellIndexPath)(NSIndexPath *oneClassfyIndexPath);
//上个页面选择了第几个类目，进来后要根据这个滚动到对应的类目
@property (nonatomic,assign)NSInteger superiorSelectIndex;
@end
