//
//  YSNearHeaderView.h
//  jingGang
//
//  Created by dengxf on 17/6/7.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSNearAdContentModel;
@class YSNearHeaderView;
@class YSNearAdContent;
@class YSGroupClassItem;
@class YSAdContentItem;
@protocol YSNearHeaderViewDelegate <NSObject>
@optional
// 点击搜索
- (void)headerView:(YSNearHeaderView *)nearHeaderView searchButtonClick:(UIButton *)button;

// 点击轮播图
- (void)headerView:(YSNearHeaderView *)nearHeaderView didSelectCycleViewItemAtIndex:(NSInteger)index;

// 点击周边分类按钮
- (void)headerView:(YSNearHeaderView *)nearHeaderView didSelecteClassifyItem:(YSGroupClassItem *)item;

// 广告模板
- (void)headerView:(YSNearHeaderView *)nearHeaderView clickAdvertItem:(YSNearAdContent *)adItem itemIndex:(NSInteger)index;

@end

@interface YSNearHeaderView : UIView

+ (CGFloat)headerViewHeight;


//- (CGFloat)headerViewHeight;

@property (assign, nonatomic) id<YSNearHeaderViewDelegate> delegate;

@property (strong,nonatomic) NSArray *imageURLStringsGroup;

@property (strong,nonatomic) YSNearAdContentModel *adContentModel;

// 新接口广告模型
@property (strong,nonatomic) YSAdContentItem *adContentItem;

@property (strong,nonatomic) NSArray *groupClassDatasources;

/**
 *  更新视图尺寸 */
- (void)updateFrame;

@end
