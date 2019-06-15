//
//  YSFriendCircleDetailController.h
//  jingGang
//
//  Created by dengxf on 16/7/30.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSBaseController.h"

/**
 *  健康圈帖子详情 */
@class YSFriendCircleFrame;
@interface YSFriendCircleDetailController : YSBaseController

- (instancetype)initWithUid:(NSString *)uid postId:(NSString *)postid;

- (instancetype)initWithCircleModel:(YSFriendCircleFrame *)circleModel;

@end
