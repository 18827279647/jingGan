//
//  YSSiftBgView.h
//  jingGang
//
//  Created by HanZhongchou on 2017/2/21.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSSiftBgView : UIView




- (instancetype)initWithSiftViewFrame:(CGRect)frame;

- (void)showView;
- (void)hideView;

//筛选结果返回
@property (nonatomic, copy) void (^siftBlock)(BOOL isStockSelect,BOOL isFreeFranking,BOOL isUniteGoods);
@end
