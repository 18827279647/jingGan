//
//  YSCommodityHeaderView.h
//  jingGang
//
//  Created by Eric Wu on 2019/6/2.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSCommodityHeaderView : UIView
//轮播图数据
@property (nonatomic, strong) NSMutableArray * commenModelArray;
//二级菜单
@property (nonatomic, strong) NSMutableArray * ListModelArray;
//广告区域
@property (nonatomic, strong) NSMutableArray * AdContentArray;

//二级菜单背景颜色
@property (copy, nonatomic) NSString *backColor;
//二级菜单背景图片
@property (copy, nonatomic) NSString *backImage;

@end

NS_ASSUME_NONNULL_END
