//
//  PDNumTableViewCell.h
//  jingGang
//
//  Created by whlx on 2019/3/8.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDNumberListModels.h"
#import "YSDateConutDown.h"
@interface PDNumTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^change_controllerA_labelTitleBlock)(NSString *orderId,NSString * userid);
@property (weak, nonatomic) IBOutlet UIButton *pdbutton;

@property (nonatomic,strong)PDNumberListModels * models;

@property (weak, nonatomic) IBOutlet UIImageView *touxiangOne;
@property (nonatomic,strong) YSDateConutDown *dateConutDown;
@property (weak, nonatomic) IBOutlet UIImageView *touxiangtwo;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (nonatomic,assign) BOOL istime;

@property (nonatomic,strong) NSString * orderId;
@property (nonatomic,strong) NSString * useid;
@end
