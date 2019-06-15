//
//  LJTableViewCell.h
//  jingGang
//
//  Created by whlx on 2019/3/6.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHJModel.h"
@interface LJTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dianpuLabel;
@property (weak, nonatomic) IBOutlet UILabel *jageLabel;
@property (weak, nonatomic) IBOutlet UILabel *sytiaojianLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *lingButton;
@property (weak, nonatomic) IBOutlet UIView *jinduLabel;
@property (strong,nonatomic)YHJModel *YHJModel;
@property (weak, nonatomic) IBOutlet UILabel *yiqiangLabel;
@property (weak, nonatomic) IBOutlet UIImageView *yilingquImageView;

@end
