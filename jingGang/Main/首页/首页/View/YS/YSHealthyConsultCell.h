//
//  YSHealthyConsultCell.h
//  jingGang
//
//  Created by dengxf on 17/5/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KHealthyConsultMargin 10.0

@interface YSHealthyConsultCell : UITableViewCell

+ (instancetype)setupWithTableView:(UITableView *)tableView consultCallback:(voidCallback)consullt;

@property (strong,nonatomic) UIImage *consultImage;

@end
