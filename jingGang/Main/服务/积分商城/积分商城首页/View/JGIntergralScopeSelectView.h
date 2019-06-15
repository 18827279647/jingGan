//
//  JGIntergralScopeSelectView.h
//  jingGang
//
//  Created by HanZhongchou on 16/7/29.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGIntergralScopeSelectViewDelegate <NSObject>
/**
 *  点击item返回积分范围
 *
 *  @param minIntegral 最小积分范围
 *  @param maxIntefral 最大积分范围
 */
- (void)JGIntergralScopeDidSelectItemAtMinIntegral:(NSString *)minIntegral MaxIntegral:(NSString *)maxIntefral;

@end

@interface JGIntergralScopeSelectView : UIView


@property (nonatomic,assign) id<JGIntergralScopeSelectViewDelegate>delegate;

@end
