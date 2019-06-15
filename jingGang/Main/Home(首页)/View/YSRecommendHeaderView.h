//
//  YSRecommendHeaderView.h
//  jingGang
//
//  Created by 左衡 on 2018/7/28.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "YSButtonCollectionView.h"
#import "YSNearAdContentModel.h"
#import "YSAdContentItem.h"
@class YSWeatherInfo,YSUserCustomer,YSQuestionnaire,YSNearAdContentModel,YSHealthManageHeaderView,YSNearAdContent,YSAdContentItem;

@protocol YSRecommedViewHeaderViewDelegate <NSObject>

- (void)headerView:(YSHealthManageHeaderView *)headerView clickAdItem:(YSNearAdContent *)adContentModel itemIndex:(NSInteger)index;

@end
@interface YSRecommendHeaderView : UIView<SDCycleScrollViewDelegate>
@property (nonatomic, strong)NSArray *imageURLStringsGroup;
@property (nonatomic, weak) id<SDCycleScrollViewDelegate,UICollectionViewDelegate,YSRecommedViewHeaderViewDelegate> delegate;
@property (strong,nonatomic) YSNearAdContentModel *adContentModel;
// 新接口广告模型
@property (strong,nonatomic) YSAdContentItem *adContentItem;

@end
