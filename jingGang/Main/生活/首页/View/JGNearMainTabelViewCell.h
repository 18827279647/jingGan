//
//  JGNearMainTabelViewCell.h
//  jingGang
//
//  Created by HanZhongchou on 16/7/21.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecommendStoreModel;
@interface JGNearMainTabelViewCell : UITableViewCell

//周边首页好店推荐数据模型
@property (nonatomic,strong)RecommendStoreModel *model;


//搜索分类筛选商店列表
- (void)configWithObject:(id)object;

@end
