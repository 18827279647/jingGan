//
//  YSConTableViewCell.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/16.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSConTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *conbackImage;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *textlabel;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (weak, nonatomic) IBOutlet UILabel *laiYuanlabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;

@end

NS_ASSUME_NONNULL_END
