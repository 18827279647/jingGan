//
//  YSLabourStrengthCell.h
//  jingGang
//
//  Created by dengxf on 2017/9/16.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSLabourStrengthCell : UITableViewCell

- (NSArray *)datas;

+ (instancetype)setupCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)inedxPath;

@end
