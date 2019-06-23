//
//  RXMotionTableViewCell.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/23.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CircleLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface RXMotionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *motionTitlelabel;
@property (weak, nonatomic) IBOutlet UIButton *motionlishiButton;
@property (weak, nonatomic) IBOutlet UIButton *motionyueButton;
@property (weak, nonatomic) IBOutlet UIButton *motionzhouButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *motionCenterlabel;
@property (weak, nonatomic) IBOutlet UILabel *motionCenterNumberlabel;
@property (weak, nonatomic) IBOutlet UILabel *motionCenterMulabel;
@property (weak, nonatomic) IBOutlet UIImageView *reImage;
@property (weak, nonatomic) IBOutlet UILabel *rexiaolabel;
@property (weak, nonatomic) IBOutlet UILabel *lejulabel;
@property (weak, nonatomic) IBOutlet UIImageView *jiaoimage;
@property (weak, nonatomic) IBOutlet UILabel *motionNamelabel;

@end

NS_ASSUME_NONNULL_END
