//
//  RXUserInfoVIew.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/18.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RXUserInfoVIew : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInfoTop;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *wearherLable;
@property (weak, nonatomic) IBOutlet UILabel *shuoMingLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weghtlabel;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;
@property (weak, nonatomic) IBOutlet UIButton *vipButton;
@property (weak, nonatomic) IBOutlet UILabel *vipNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *yichangbackImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yichangBottom;
@property (weak, nonatomic) IBOutlet UIImageView *yichangImage;

@property (weak, nonatomic) IBOutlet UILabel *yichanglabel;

@end

NS_ASSUME_NONNULL_END
