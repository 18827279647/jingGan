//
//  YSHealthManageHeaderView.h
//  jingGang
//
//  Created by dengxf on 16/7/22.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSBaseInfoView.h"
#import "YSJirirenwubushuView.h"
@class YSWeatherInfo,YSUserCustomer,YSQuestionnaire,YSNearAdContentModel,YSHealthManageHeaderView,YSNearAdContent,YSAdContentItem;

@protocol YSHealthManageHeaderViewDelegate <NSObject>

- (void)headerView:(YSHealthManageHeaderView *)headerView clickAdItem:(YSNearAdContent *)adContentModel itemIndex:(NSInteger)index;

@end

@interface YSHealthManageHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame
          buttonClickCallback:(void(^)(NSInteger index))buttonCallback clickCallback:(id_block_t)clickCallback ;

- (void)setBaseInfoWithCity:(NSString *)city weatherInfo:(YSWeatherInfo *)weatherInfo;
- (void)setUserInfoWithUserCustomer:(YSUserCustomer *)userInfo questionnaire:(YSQuestionnaire *)questionnaire;

@property (strong,nonatomic) YSJirirenwubushuView *jrrwView;
// 动态获取头部高度
+ (CGFloat)tableViewHearderHeight;
@property (strong,nonatomic) YSBaseInfoView *baseInfoView;
@property (copy , nonatomic) void (^userClickedTestActionCallback)(NSString *);
//去赚积分
@property (copy , nonatomic) void (^goMissionButtonClickBlock)(void);

@property (strong,nonatomic) YSNearAdContentModel *adContentModel;

// 新接口广告模型
@property (strong,nonatomic) YSAdContentItem *adContentItem;

@property (assign, nonatomic) id<YSHealthManageHeaderViewDelegate> delegate;


@end
