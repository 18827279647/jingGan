//
//  YSCircleDetailCell.h
//  jingGang
//
//  Created by dengxf11 on 16/9/2.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSCommentFrame.h"

@interface YSCircleDetailCell : UITableViewCell

@property (strong,nonatomic) YSCommentFrame *commentFrame;

+ (instancetype)configCircelDetailCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property (copy , nonatomic) void(^didSelectedReplyCellCallback)(YSCommentFrame *frame);

@end
