//
//  RXbutlerServiceView.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/20.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RXShowButlerServiceView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *vipIconImage;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;

@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *oneImage;

@property (weak, nonatomic) IBOutlet UIImageView *oneSelectImage;

@property (weak, nonatomic) IBOutlet UIButton *youButton;
@property (weak, nonatomic) IBOutlet UILabel *youlabel;
@property (weak, nonatomic) IBOutlet UILabel *helabel;
@property (weak, nonatomic) IBOutlet UIButton *lijiButton;


@property (weak, nonatomic) IBOutlet UILabel *showTimelabel;

@property (weak, nonatomic) IBOutlet UILabel *showMoneylabel;

@property (weak, nonatomic) IBOutlet UILabel *titleNamelabel;

@property (weak, nonatomic) IBOutlet UIButton *jianButton;
@property (weak, nonatomic) IBOutlet UILabel *shuNumberlabel;

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@end

NS_ASSUME_NONNULL_END
