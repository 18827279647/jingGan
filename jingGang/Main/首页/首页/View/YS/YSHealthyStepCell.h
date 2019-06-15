//
//  YSHealthyStepCell.h
//  jingGang
//
//  Created by dengxf on 16/7/23.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHealthyStepCellHeight (208.0 / 2 + 24 +4)

@interface YSHealthyStepCell : UITableViewCell

+ (instancetype)setupWithTableView:(UITableView *)tableView data:(NSDictionary *)data updateStep:(voidCallback)updateCallback;
@end
