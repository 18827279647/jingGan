//
//  RXHealthyTableViewCell.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RXHealthyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *conterlabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconimage;
@property (weak, nonatomic) IBOutlet UIButton *dianButton;
@property (weak, nonatomic) IBOutlet UIButton *pingButton;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;


@property (weak, nonatomic) IBOutlet UILabel *twoConterlabel;
@property (weak, nonatomic) IBOutlet UIImageView *twoIconimage;
@property (weak, nonatomic) IBOutlet UIButton *twoDianButton;
@property (weak, nonatomic) IBOutlet UIButton *twoPingButton;
@property (weak, nonatomic) IBOutlet UIButton *twoFlashButton;

@property (weak, nonatomic) IBOutlet UILabel *twoTitellabel;
@property (weak, nonatomic) IBOutlet UIButton *twoGengButton;

@end

NS_ASSUME_NONNULL_END
