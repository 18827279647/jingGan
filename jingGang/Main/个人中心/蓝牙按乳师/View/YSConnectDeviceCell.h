//
//  YSConnectDeviceCell.h
//  jingGang
//
//  Created by dengxf on 17/6/27.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSConnectDeviceCell : UITableViewCell

@property (strong,nonatomic) NSDictionary *dataDict;
+ (instancetype)setupCellWithTableView:(UITableView *)tableView;

@end
