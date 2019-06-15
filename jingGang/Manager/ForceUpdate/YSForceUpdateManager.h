//
//  YSForceUpdateManager.h
//  jingGang
//
//  Created by Eric Wu on 2019/6/2.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSForceUpdateView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSForceUpdateManager : NSObject
@property (strong, nonatomic) YSForceUpdateView *updateView;
+ (instancetype)sharedManager;
- (void)checkNeedUpdate;
@end

NS_ASSUME_NONNULL_END
