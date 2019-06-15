//
//  YSFriendCircleCell.h
//  jingGang
//
//  Created by dengxf on 16/7/23.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSFriendCircleFrame.h"
#import "YSFriendCircleToolsView.h"

#define YSHealthyCircleNickFont JGFont(15)


/**
 *  健康圈cell */
@interface YSFriendCircleCell : UITableViewCell

+ (instancetype)setupCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property (strong,nonatomic) YSFriendCircleFrame *circleFrame;

/**
 *  底部工具点击事件 */
@property (copy , nonatomic) void(^friendCircleClickCallback)(ToolsButtonsClickType type);

/**
 *  点击配图点击事件 */
@property (copy , nonatomic) void(^clickImageCallback)(NSInteger imageIndex);

/**
 *  点击用户头像 */
@property (copy , nonatomic) voidCallback clickUserIconCallback;

@property (copy , nonatomic) void(^clickTopicCallback)(NSString *topic);

@property (assign, nonatomic) BOOL shouldShowDeleteButton;

@property (copy , nonatomic) voidCallback deleteCircleCallback;

@end
