//
//  mainViewController.h
//  jingGang
//
//  Created by yi jiehuang on 15/5/12.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "VApiManager.h"
#import "AccessToken.h"
#import "JGBaseViewController.h"

@interface mainViewController : JGBaseViewController<UITableViewDelegate,UITableViewDataSource>

/**
 *  展示蒙版演示 */
- (void)showMaskGuideCompleted:(voidCallback)completed;

@end
