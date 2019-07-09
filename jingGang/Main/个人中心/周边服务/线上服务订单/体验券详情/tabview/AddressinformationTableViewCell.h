//
//  AddressinformationTableViewCell.h
//  jingGang
//
//  Created by 荣旭 on 2019/7/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressinformationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addresslabel;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *addressXlabel;
@property (weak, nonatomic) IBOutlet UILabel *julilabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;


-(void)addressinformationWithData:(NSDictionary*)dict;
@end

NS_ASSUME_NONNULL_END
