//
//  AppDelegate+JGActivity.h
//  jingGang
//
//  Created by dengxf on 16/2/17.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "AppDelegate.h"
#import "JGDropdownMenu.h"
#import "JGActivityHelper.h"

@interface AppDelegate (JGActivity)

@property (strong,nonatomic) JGDropdownMenu *activituMenu;

/**
 *  加载当前活动信息
    App启动时会请求加载信息
    健康管理、健康圈、周边、商城首页都会在viewDidAppear调用后4秒，再次请求更新活动信息
 */
- (void)loadActivityNeedPop:(BOOL)needPop;

/**
 *  用户签到 */
- (void)queryUserDidCheckWithState:(void(^)(YSUserSignViewState state))state;
@end
