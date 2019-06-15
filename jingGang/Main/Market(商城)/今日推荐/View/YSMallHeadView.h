//
//  YSMallHeadView.h
//  jingGang
//
//  Created by whlx on 2019/5/7.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "MySegementView.h"

@class RecommenModel;
@class YSMallHeadView;
@class AdVertisingListModel;
@class ChanneListModel;
@protocol YSMallHeadViewDelegate <NSObject>
//点击轮播图
- (void)YSMallHeadView:(YSMallHeadView *)YSMallHeadView AndRecommenModel:(RecommenModel *)model;
//点击二级菜单栏
- (void)YSMallHeadView:(YSMallHeadView *)YSMallHeadView AndTwoNavi:(ChanneListModel *)model;
//点击广告位
- (void)YSMallHeadView:(YSMallHeadView *)YSMallHeadView AndAdVertising:(AdVertisingListModel *)model;
@end

NS_ASSUME_NONNULL_BEGIN

@interface YSMallHeadView : UIView

@property (nonatomic, strong) NSMutableArray * commenModelArray;

@property (nonatomic, strong) NSMutableArray * ListModelArray;

@property (nonatomic, strong) NSMutableArray * AdContentArray;

//时间分组
@property (nonatomic, strong) NSMutableArray *GroupListArray;

@property (nonatomic, weak) id<YSMallHeadViewDelegate>delegate;

//二级菜单背景颜色
@property (copy, nonatomic) NSString *backColor;
//二级菜单背景图片
@property (copy, nonatomic) NSString *backImage;

@property (nonatomic, strong) MySegementView * SegementView;

@end


NS_ASSUME_NONNULL_END
