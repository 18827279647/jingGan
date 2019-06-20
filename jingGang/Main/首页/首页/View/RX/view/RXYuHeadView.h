//
//  RXYuHeadView.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RXYuHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titelabel;

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet UIButton *zhangkiaButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shuominglabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headTop;
@property (weak, nonatomic) IBOutlet UILabel *shujulabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhangkileft;
@property (weak, nonatomic) IBOutlet UILabel *laiyuanlabel;
@property (weak, nonatomic) IBOutlet UILabel *danweilabel;

@end

NS_ASSUME_NONNULL_END
