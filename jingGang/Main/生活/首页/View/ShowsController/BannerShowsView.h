//
//  BannerShowsView.h
//  jingGang
//
//  Created by HanZhongchou on 16/8/25.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerShowsView : UIView


@property (strong, nonatomic) NSArray *arrayDataSource;  // 图片数组
@property (assign, nonatomic) NSInteger pageNum;   // 页面图片个数

@property (copy,nonatomic) void (^goodsClassListDidSelectBlock)(NSNumber *circleID,NSInteger selectNum);
/**
 *  初始化预留接口  可以应用本地和网络
 *  本视图可以用于类似美图/糯米 等分类菜单
 *  @param frame  frame
 *  @param images 图片 url 数组
 *  @param titles 文字 url 数组
 *  @param num    页面 num 图片数量  ps. // num 应为整数 eg. 8 / 10 ......
 */

- (instancetype)initBannerViewWithFrame:(CGRect)frame BannerInfos:(NSArray *)array PageNumber:(NSInteger)num;
@end
