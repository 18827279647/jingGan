//
//  BankTableViewCell.h
//  Operator_JingGang
//
//  Created by whlx on 2019/4/15.
//  Copyright © 2019年 Dengxf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bankImage;
@property (weak, nonatomic) IBOutlet UILabel *bankName;

@end

NS_ASSUME_NONNULL_END
