//
//  YSTopicSearchController.h
//  jingGang
//
//  Created by dengxf on 16/8/4.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSFriendCircleRequestManager.h"

@interface YSTopicSearchController : UIViewController

- (instancetype)initWithSelectedTopicCallback:(void(^)(CircleLabel *))selectedCallback;

@end
