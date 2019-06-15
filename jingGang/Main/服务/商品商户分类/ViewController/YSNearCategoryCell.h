//
//  YSNearCategoryCell.h
//  jingGang
//
//  Created by dengxf on 17/7/12.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSNearCategoryCell : UITableViewCell

+ (instancetype)setupTableView:(UITableView *)tableView textAlignment:(NSTextAlignment)textAlignment showSepline:(BOOL)show text:(NSString *)text isMain:(BOOL)isMain;
@property (strong,nonatomic) UILabel *textLab1;
@property (strong,nonatomic) UIView *seplineView1;
@end
