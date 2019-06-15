//
//  YSHomeTipManager.h
//  jingGang
//
//  Created by Eric Wu on 2019/6/2.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSHomeTipView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSHomeTipManager : NSObject
@property (strong, nonatomic) YSHomeTipView *tipView;
@property (assign, nonatomic) CGPoint origin;

@property (weak, nonatomic) UIView *supperView;
+ (instancetype)sharedManager;
- (void)checkNeedShow;
@end

NS_ASSUME_NONNULL_END
