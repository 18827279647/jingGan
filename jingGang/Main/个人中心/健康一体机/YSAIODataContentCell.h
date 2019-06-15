//
//  YSAIODataContentCell.h
//  jingGang
//
//  Created by dengxf on 2017/9/1.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSAIODataItem;

@interface YSAIODataContentCell : UITableViewCell

+ (instancetype)setupCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property (strong,nonatomic) YSAIODataItem *dataItem;

@end
