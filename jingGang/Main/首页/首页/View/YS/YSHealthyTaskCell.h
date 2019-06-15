//
//  YSHealthyTaskCell.h
//  jingGang
//
//  Created by dengxf on 16/7/23.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
// 165
#define kHealthyTaskCellHeight(x) ( x == 140 ? 145.0f:63.0f)

@interface YSHealthyTaskCell : UITableViewCell

+ (instancetype)setupCellWithTableView:(UITableView *)tableView datas:(NSDictionary *)datas indexPath:(NSIndexPath *)indexPath;

@property (copy , nonatomic) voidCallback addHealthyTaskCallback;
@property (copy , nonatomic) msg_block_t completeTaskCallback;



@end
