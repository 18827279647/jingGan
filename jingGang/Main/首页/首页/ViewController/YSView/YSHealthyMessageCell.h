//
//  YSHealthyMessageCell.h
//  jingGang
//
//  Created by dengxf on 16/7/25.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHealthyMessageCellHeight 100

@interface YSHealthyMessageCell : UITableViewCell

+ (instancetype)setupCellWithTableView:(UITableView *)tableView data:(NSDictionary *)dict;

@end
