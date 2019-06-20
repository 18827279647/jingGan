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

@end

NS_ASSUME_NONNULL_END
