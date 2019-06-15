//
//  JGIntegralShopHeaderView.h
//  jingGang
//
//  Created by HanZhongchou on 16/7/28.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGIntegralShopHeaderView : UIView


- (void)requestUserInfo;

@property(copy,nonatomic) void (^goIntegralWithMissionBlock)(void);

@end
